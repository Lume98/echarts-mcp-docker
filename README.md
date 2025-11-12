# MCP ECharts Docker

MCP ECharts 的 Docker 化部署方案，提供简单快捷的容器化运行方式。

## 📋 项目简介

本项目提供了 MCP ECharts 服务的 Docker 部署方案，支持通过 Docker 或 Docker Compose 快速启动服务。

## 🚀 快速开始

### 前置要求

- Docker 已安装并运行
- Docker Compose（可选，用于更便捷的管理）

### 方式一：使用脚本（推荐）

#### Windows 用户

```bash
# 构建镜像
build.bat

# 运行容器
run.bat
```

#### Linux/Mac 用户

```bash
# 构建镜像
./build.sh

# 运行容器
./run.sh
```

### 方式二：使用 Docker Compose

```bash
# 构建并启动服务
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

### 方式三：使用 Docker 命令

```bash
# 构建镜像
docker build -t mcp-echarts:latest .

# 运行容器
docker run -d \
  --name mcp-echarts \
  -p 3033:3033 \
  -e TRANSPORT=sse \
  -e PORT=3033 \
  -e ENDPOINT=/sse \
  --restart unless-stopped \
  mcp-echarts:latest
```

### 方式四：使用 GitHub Actions 自动构建的镜像

项目配置了 GitHub Actions 自动构建工作流，每次推送到 `main` 分支或创建新标签时，会自动构建并推送 Docker 镜像。

#### 使用 GitHub Container Registry 镜像

```bash
# 拉取镜像
docker pull ghcr.io/<your-username>/mcp-echarts-docker:latest

# 运行容器
docker run -d \
  --name mcp-echarts \
  -p 3033:3033 \
  -e TRANSPORT=sse \
  -e PORT=3033 \
  -e ENDPOINT=/sse \
  --restart unless-stopped \
  ghcr.io/<your-username>/mcp-echarts-docker:latest
```

#### 使用 Docker Hub 镜像（需配置）

如果配置了 Docker Hub 的 Secrets，镜像也会自动推送到 Docker Hub：

```bash
# 拉取镜像
docker pull <your-dockerhub-username>/mcp-echarts:latest

# 运行容器
docker run -d \
  --name mcp-echarts \
  -p 3033:3033 \
  -e TRANSPORT=sse \
  -e PORT=3033 \
  -e ENDPOINT=/sse \
  --restart unless-stopped \
  <your-dockerhub-username>/mcp-echarts:latest
```

> **注意**：请将 `<your-username>` 和 `<your-dockerhub-username>` 替换为实际的用户名。

## 🌐 访问服务

启动后，可以通过以下地址访问：

- **SSE 传输**: `http://localhost:3033/sse`
- **Streamable 传输**: `http://localhost:3033/mcp`

如果部署在远程服务器，将 `localhost` 替换为服务器 IP 地址。

## 📁 项目结构

```
mcp-echarts-docker/
├── .github/
│   └── workflows/
│       └── docker-build.yml  # GitHub Actions 自动构建工作流
├── Dockerfile              # Docker 镜像构建文件
├── docker-compose.yml     # Docker Compose 配置文件
├── build.sh               # Linux/Mac 构建脚本
├── build.bat              # Windows 构建脚本
├── run.sh                 # Linux/Mac 运行脚本
├── run.bat                # Windows 运行脚本
├── README.md              # 项目说明文档（本文件）
└── README-Docker.md       # 详细的 Docker 部署指南
```

## ⚙️ 配置说明

### 环境变量

- `TRANSPORT`: 传输方式，可选值：`sse` 或 `streamable`（默认：`sse`）
- `PORT`: 服务端口（默认：`3033`）
- `ENDPOINT`: 端点路径
  - SSE 默认：`/sse`
  - Streamable 默认：`/mcp`

### MinIO 配置（可选）

如果需要使用 MinIO 对象存储，可以在 `docker-compose.yml` 中配置以下环境变量：

```yaml
environment:
  - MINIO_ENDPOINT=your-minio-endpoint
  - MINIO_PORT=9000
  - MINIO_USE_SSL=false
  - MINIO_ACCESS_KEY=your-access-key
  - MINIO_SECRET_KEY=your-secret-key
  - MINIO_BUCKET_NAME=mcp-echarts
```

## 🔧 常用命令

### 查看容器日志

```bash
docker logs -f mcp-echarts
```

### 停止容器

```bash
docker stop mcp-echarts
```

### 重启容器

```bash
docker restart mcp-echarts
```

### 删除容器

```bash
docker rm -f mcp-echarts
```

### 进入容器

```bash
docker exec -it mcp-echarts sh
```

## 🔄 CI/CD 自动构建

项目配置了 GitHub Actions 工作流，支持自动构建和推送 Docker 镜像。

### 触发条件

- 推送到 `main` 或 `master` 分支
- 创建版本标签（格式：`v*`，如 `v1.0.0`）
- 手动触发（workflow_dispatch）
- Pull Request（仅构建，不推送）

### 镜像标签

- `latest`：默认分支的最新构建
- `<branch-name>`：分支名称标签
- `v<version>`：版本标签（如 `v1.0.0`）
- `<major>.<minor>`：主次版本标签（如 `1.0`）
- `<major>`：主版本标签（如 `1`）
- `<branch>-<sha>`：分支和提交 SHA 标签

### 配置 Docker Hub（可选）

如果需要同时推送到 Docker Hub，需要在 GitHub 仓库设置中添加以下 Secrets：

1. 进入仓库 Settings → Secrets and variables → Actions
2. 添加以下 Secrets：
   - `DOCKERHUB_USERNAME`：Docker Hub 用户名
   - `DOCKERHUB_TOKEN`：Docker Hub 访问令牌（在 Docker Hub → Account Settings → Security 中创建）

> 📖 **详细配置步骤**：请参考 [GITHUB_SETUP.md](./GITHUB_SETUP.md) 获取完整的配置指南和常见问题解答。

### 查看构建状态

在 GitHub 仓库的 Actions 标签页可以查看构建历史和状态。

## 📚 更多文档

- [README-Docker.md](./README-Docker.md) - 详细的 Docker 部署指南、故障排查和生产环境建议
- [GITHUB_SETUP.md](./GITHUB_SETUP.md) - GitHub Actions 配置指南和常见问题解答

## 📝 许可证

本项目遵循原项目的许可证。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

