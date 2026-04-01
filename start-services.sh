#!/bin/bash

# 启动 openclaw 服务
echo "Starting openclaw service..."
cp /app/openclaw.json /data/.openclaw/openclaw.json
cp /app/exec-approvals.json /data/.openclaw/exec-approvals.json
cp /app/.env /data/.openclaw/.env
chmod 600 /data/.openclaw/openclaw.json
chmod 600 /data/.openclaw/exec-approvals.json
openclaw gateway --allow-unconfigured --verbose --port 3000 --bind lan
