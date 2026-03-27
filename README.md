# fly.io部署Openclaw

部署内容：OpenRouter+Lark+Weather

OpenClaw 部署配置，集成飞书（Lark）机器人，部署在 Fly.io 平台。

## 项目特性

- 基于 Node.js 22-slim 的 Docker 镜像
- 自动更新 OpenClaw 到最新版本
- 集成飞书（Lark）机器人支持
- ClawHub CLI 集成
- 持久化数据存储
- 私有部署（无公开 IP 暴露）

## 快速开始

### 前置要求

- [Fly.io](https://fly.io) 账户
- Fly CLI 已安装
- 飞书（Lark）应用凭证
- ClawHub Token

### 配置步骤

1. 克隆或下载此仓库
2. 配置环境变量：

```bash
cp .env.example .env
```

编辑 `.env` 文件，填入以下关键配置：

- `OPENCLAW_GATEWAY_TOKEN` - OpenClaw 网关认证令牌
- `CLAWHUB_TOKEN` - ClawHub 访问令牌
- `FEISHU_APP_ID` - 飞书应用 ID
- `FEISHU_APP_SECRET` - 飞书应用密钥
- 其他所需的 API 密钥（如 OpenRouter、Brave 等）

1. 配置 Fly.io 应用：

编辑 `fly.toml`，根据需要修改：

- `app` - 应用名称
- `primary_region` - 部署区域

1. 部署到 Fly.io：

```bash
fly launch
fly deploy
```

## 访问方式

由于此配置为私有部署，无公开 IP 暴露，可通过以下方式访问：

### 1. 使用 Fly Proxy

```bash
fly proxy 3000:3000 -a cyeamclaw
```

然后在浏览器访问 `http://localhost:3000`

### 2. SSH 控制台

```bash
fly ssh console
```

## 项目结构

```
.
├── .env.example          # 环境变量示例
├── Dockerfile            # Docker 构建文件
├── fly.toml              # Fly.io 配置
├── openclaw.json         # OpenClaw 主配置
├── workflows/
│   ├── fly.yml          # GitHub Actions 自动部署
│   └── notify.yml       # 通知工作流
└── README.md             # 本文件
```

## 主要配置说明

### openclaw\.json

- **agents.defaults.model** - 默认使用的 AI 模型
- **channels.feishu** - 飞书机器人配置
- **gateway** - 网关配置（端口、认证等）
- **tools** - 工具配置（搜索、浏览器等）

### Dockerfile

包含以下预装工具：

- curl, wget, git
- ffmpeg, jq
- Chromium 浏览器
- 多语言字体支持
- vim 编辑器

## 自动部署

项目配置了 GitHub Actions 工作流，推送到 `master` 分支时自动部署到 Fly.io。需在 GitHub Secrets 中配置 `FLY_API_TOKEN`。

## 数据持久化

Fly.io 挂载卷 `/data` 用于持久化 OpenClaw 数据和配置。

## 许可证

详见 [LICENSE](LICENSE) 文件。
