# 基础镜像：永远拉取最新版 OpenClaw（每次部署自动更新）
FROM node:22-slim

# 设置环境变量
ENV BUN_INSTALL="/usr/local" \
  PATH="/usr/local/bin:$PATH" \
  DEBIAN_FRONTEND=noninteractive


RUN chown node:node /app
RUN apt-get update && apt-get install -y vim

# 2. 插件安装（作为 node 用户以避免后期权限修复带来的镜像膨胀）
RUN mkdir -p /data/.openclaw/workspace /data/.openclaw/extensions && \
  chown -R node:node /data

ENV NODE_ENV=production
USER node

RUN npm install -g openclaw@latest

# 暴露端口
EXPOSE 3000

# 设置工作目录
WORKDIR /app
COPY openclaw.json /data/.openclaw/openclaw.json
COPY .env /data/.openclaw/.env

RUN chmod 600 /app/config/openclaw.json
