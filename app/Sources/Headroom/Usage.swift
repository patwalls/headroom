import Foundation
import Security

// The data spine: Keychain OAuth token → Anthropic usage endpoint → utilization.
// TRUST POSITION (VISION §0.5): the token is sent to api.anthropic.com and NOWHERE
// else — never logged, never written, never phoned home.

struct Usage {
    struct Window {
        let utilization: Double
        let resetsAt: Date?
    }
    let fiveHour: Window
    let sevenDay: Window
}

enum HeadroomError: Error, CustomStringConvertible {
    case keychain(OSStatus)
    case credentialShape
    case http(Int)
    case network(String)
    case responseShape

    var description: String {
        switch self {
        case .keychain(let status):
            return "Keychain read failed (status \(status)) — is Claude Code installed?"
        case .credentialShape:
            return "Unexpected credential format in Keychain"
        case .http(401):
            return "Token expired — open Claude Code once to refresh it"
        case .http(let code):
            return "Usage endpoint answered HTTP \(code)"
        case .network(let msg):
            return "Network error: \(msg)"
        case .responseShape:
            return "Unexpected usage response shape"
        }
    }
}

enum KeychainToken {
    /// Reads the OAuth access token Claude Code keeps in the macOS Keychain
    /// (generic password, service "Claude Code-credentials").
    static func read() throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: "Claude Code-credentials",
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status == errSecSuccess, let data = item as? Data else {
            throw HeadroomError.keychain(status)
        }
        guard
            let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
            let oauth = root["claudeAiOauth"] as? [String: Any],
            let token = oauth["accessToken"] as? String
        else {
            throw HeadroomError.credentialShape
        }
        return token
    }
}

enum UsageClient {
    static let endpoint = URL(string: "https://api.anthropic.com/api/oauth/usage")!

    /// Fetches the raw usage JSON. Synchronous; call off the main thread.
    static func fetchRaw(token: String) throws -> Data {
        var request = URLRequest(url: endpoint)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("oauth-2025-04-20", forHTTPHeaderField: "anthropic-beta")
        request.timeoutInterval = 15

        var result: Result<Data, HeadroomError> = .failure(.network("no response"))
        let done = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request) { data, response, error in
            defer { done.signal() }
            if let error {
                result = .failure(.network(error.localizedDescription))
                return
            }
            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
            guard code == 200, let data else {
                result = .failure(.http(code))
                return
            }
            result = .success(data)
        }.resume()
        done.wait()
        return try result.get()
    }

    static func fetch(token: String) throws -> Usage {
        let data = try fetchRaw(token: token)
        guard let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw HeadroomError.responseShape
        }
        func window(_ key: String) throws -> Usage.Window {
            guard let obj = root[key] as? [String: Any],
                  let utilization = obj["utilization"] as? Double
            else { throw HeadroomError.responseShape }
            var resetsAt: Date?
            if let iso = obj["resets_at"] as? String {
                let parser = ISO8601DateFormatter()
                parser.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                resetsAt = parser.date(from: iso)
                    ?? ISO8601DateFormatter().date(from: iso)
            }
            return Usage.Window(utilization: utilization, resetsAt: resetsAt)
        }
        return Usage(fiveHour: try window("five_hour"), sevenDay: try window("seven_day"))
    }
}
