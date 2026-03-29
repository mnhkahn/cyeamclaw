# 基础镜像：永远拉取最新版 OpenClaw（每次部署自动更新）
FROM node:22-slim

WORKDIR /app

# 设置环境变量
ENV BUN_INSTALL="/usr/local" \
  DEBIAN_FRONTEND=noninteractive \
  NODE_ENV=production \
  OPENCLAW_PREFER_PNPM=1 \
  NODE_OPTIONS=--max-old-space-size=1536 \
  LANG=zh_CN.UTF-8 \
  LANGUAGE=zh_CN:zh \
  LC_ALL=zh_CN.UTF-8


RUN chown node:node /app
RUN apt-get update && apt-get install -y --no-install-recommends \
  curl \
  wget \
  git \
  ffmpeg \
  jq \
  chromium \
  ca-certificates \
  fonts-liberation \
  fonts-noto-cjk \
  fonts-noto-color-emoji \
  locales \
  procps \
  unzip \
  vim \
  && rm -rf /var/lib/apt/lists/* \
  && sed -i 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen \
  && locale-gen

RUN curl -sSL https://raw.githubusercontent.com/pimalaya/himalaya/master/install.sh | PREFIX=/usr/local sh

# 2. 插件安装（作为 node 用户以避免后期权限修复带来的镜像膨胀）
RUN mkdir -p /data/.openclaw/workspace /data/.openclaw/extensions /data/.openclaw/agents /data/.openclaw/credentials

# 暴露端口
EXPOSE 3000

# 设置工作目录
WORKDIR /app
COPY openclaw.json /app/openclaw.json
COPY .env /app/.env

RUN chmod 600 /app/openclaw.json && \
  echo "=== openclaw.json content ===" && \
  cat /app/openclaw.json && \
  echo "=== .env content ===" && \
  cat /app/.env

USER root

RUN npm install -g openclaw@latest && \
  npm install -g @clawhub/cli && \
  npm install -g mcporter opencode-ai@latest clawhub playwright playwright-extra && \
  npx clawhub login --no-browser --token $(grep CLAWHUB_TOKEN /app/.env | cut -d '=' -f2)

