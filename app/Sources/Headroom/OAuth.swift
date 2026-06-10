import AppKit
import CryptoKit
import Foundation
import Security

// v0.3 spike: "Sign in with Claude" — Headroom's own OAuth (PKCE) flow, so the token
// lives in Headroom's OWN Keychain item (readable silently, no consent dialog ever).
// Uses the same public OAuth client Claude Code itself authenticates with.
// TRUST POSITION unchanged: tokens go to api.anthropic.com / console.anthropic.com
// (the issuer) and NOWHERE else.

enum OAuth {
    static let clientID = "9d1c250a-e61b-44d9-88ed-5944d1962f5e"
    static let redirectURI = "https://console.anthropic.com/oauth/code/callback"
    static let tokenEndpoint = URL(string: "https://console.anthropic.com/v1/oauth/token")!
    static let keychainService = "Headroom-credentials"

    static func base64url(_ data: Data) -> String {
        data.base64EncodedString()
            .replacingOccurrences(of: "+", with: "-")
            .replacingOccurrences(of: "/", with: "_")
            .replacingOccurrences(of: "=", with: "")
    }

    static func authorizeURL(verifier: String) -> URL {
        let challenge = base64url(Data(SHA256.hash(data: Data(verifier.utf8))))
        var c = URLComponents(string: "https://claude.ai/oauth/authorize")!
        c.queryItems = [
            .init(name: "code", value: "true"),
            .init(name: "client_id", value: clientID),
            .init(name: "response_type", value: "code"),
            .init(name: "redirect_uri", value: redirectURI),
            .init(name: "scope", value: "org:create_api_key user:profile user:inference"),
            .init(name: "code_challenge", value: challenge),
            .init(name: "code_challenge_method", value: "S256"),
            .init(name: "state", value: verifier),
        ]
        return c.url!
    }

    /// Exchange the pasted `code#state` for tokens. Synchronous; call off the main thread.
    static func exchange(pasted: String, verifier: String) throws -> [String: Any] {
        let parts = pasted.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: "#")
        guard let code = parts.first, !code.isEmpty else { throw HeadroomError.credentialShape }
        let state = parts.count > 1 ? String(parts[1]) : verifier

        var request = URLRequest(url: tokenEndpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        request.httpBody = try JSONSerialization.data(withJSONObject: [
            "grant_type": "authorization_code",
            "code": String(code),
            "state": state,
            "client_id": clientID,
            "redirect_uri": redirectURI,
            "code_verifier": verifier,
        ])
        request.timeoutInterval = 20

        var result: Result<Data, HeadroomError> = .failure(.network("no response"))
        let done = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request) { data, response, error in
            defer { done.signal() }
            if let error { result = .failure(.network(error.localizedDescription)); return }
            let status = (response as? HTTPURLResponse)?.statusCode ?? -1
            guard status == 200, let data else {
                let body = data.flatMap { String(data: $0, encoding: .utf8) } ?? ""
                result = .failure(.network("token endpoint HTTP \(status): \(body)"))
                return
            }
            result = .success(data)
        }.resume()
        done.wait()

        let data = try result.get()
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              json["access_token"] is String
        else { throw HeadroomError.responseShape }
        return json
    }

    /// Store tokens in Headroom's OWN generic-password item — created by us, so we can
    /// read it forever without any consent dialog.
    static func store(_ tokens: [String: Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: tokens)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
        ]
        SecItemDelete(query as CFDictionary)
        var add = query
        add[kSecValueData as String] = data
        let status = SecItemAdd(add as CFDictionary, nil)
        guard status == errSecSuccess else { throw HeadroomError.keychain(status) }
    }

    static func storedAccessToken() -> String? {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: keychainService,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        var item: CFTypeRef?
        guard SecItemCopyMatching(query as CFDictionary, &item) == errSecSuccess,
              let data = item as? Data,
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { return nil }
        return json["access_token"] as? String
    }
}
