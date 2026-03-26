# 基础镜像：永远拉取最新版 OpenClaw（每次部署自动更新）
FROM node:22-slim

WORKDIR /app

# 设置环境变量
ENV BUN_INSTALL="/usr/local" \
  PATH="/usr/local/bin:$PATH" \
  DEBIAN_FRONTEND=noninteractive \
  NODE_ENV=production \
  OPENCLAW_PREFER_PNPM=1 \
  OPENCLAW_STATE_DIR=/data \
  OPENCLAW_HOME=/data/.openclaw \
  OPENCLAW_CONFIG_PATH=/data/.openclaw/openclaw.json \
  NODE_OPTIONS=--max-old-space-size=1536


RUN chown node:node /app
RUN apt-get update && apt-get install -y vim

# 2. 插件安装（作为 node 用户以避免后期权限修复带来的镜像膨胀）
RUN mkdir -p /data/.openclaw/workspace /data/.openclaw/extensions /data/.openclaw/agents /data/.openclaw/credentials && \
  chown -R node:node /data && \
  chown -R node:node /usr/local/lib/node_modules && \
  chown -R node:node /usr/local/bin

# 暴露端口
EXPOSE 3000

# 设置工作目录
WORKDIR /app
COPY openclaw.json /app/openclaw.json
COPY .env /app/.env

RUN chmod 600 /app/openclaw.json && \
  chown -R node:node /app && \
  echo "=== openclaw.json content ===" && \
  cat /app/openclaw.json && \
  echo "=== .env content ===" && \
  cat /app/.env

USER node

RUN npm install -g openclaw@latest

