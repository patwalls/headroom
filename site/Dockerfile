FROM node:22-slim
WORKDIR /app
COPY package.json server.js ./
COPY public ./public
# icon-512.png added 2026-06-11 — explicit copy to bust Docker layer cache
COPY public/icon-512.png ./public/icon-512.png
EXPOSE 3000
CMD ["node", "server.js"]
