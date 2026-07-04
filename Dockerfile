FROM node:22-bookworm-slim

WORKDIR /app

# 先装根依赖：同时覆盖 codex_register/src 运行时用到的 imapflow/undici/socks 等
COPY package.json package-lock.json ./
RUN npm ci

# 拷贝源码（node_modules/dist/data 已由 .dockerignore 排除）
COPY . .

# 仅做前端打包；vue-tsc 类型检查已在本地通过，容器内跳过以降低内存占用
RUN npx vite build

ENV NODE_ENV=production
# 容器内监听 8796，对外由 docker -p 3003:8796 映射
ENV PORT=8796
EXPOSE 8796

CMD ["npm", "run", "start"]
