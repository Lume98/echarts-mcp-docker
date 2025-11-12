# MCP ECharts Docker 部署指南

本文档说明如何使用 Docker 部署 mcp-echarts 服务。

## 快速开始

### 方式一：使用 Docker Compose（推荐）

1. **构建并启动服务**

```bash
docker-compose up -d
```

2. **查看服务状态**

```bash
docker-compose ps
```

3. **查看日志**

```bash
docker-compose logs -f
```

4. **停止服务**

```bash
docker-compose down
```

### 方式二：使用 Docker 命令

1. **构建镜像**

```bash
docker build -t mcp-echarts:latest .
```

2. **运行容器**

```bash
# 使用 SSE 传输（默认）
docker run -d \
  --name mcp-echarts \
  -p 3033:3033 \
  -e TRANSPORT=sse \
  -e PORT=3033 \
  -e ENDPOINT=/sse \
  mcp-echarts:latest

# 或使用 Streamable 传输
docker run -d \
  --name mcp-echarts \
  -p 3033:3033 \
  -e TRANSPORT=streamable \
  -e PORT=3033 \
  -e ENDPOINT=/mcp \
  mcp-echarts:latest
```

## 访问服务

启动后，可以通过以下地址访问：

- **SSE 传输**: `http://localhost:3033/sse`
- **Streamable 传输**: `http://localhost:3033/mcp`

如果部署在远程服务器，将 `localhost` 替换为服务器 IP 地址。

## 环境变量配置

### 基本配置

- `TRANSPORT`: 传输方式，可选值：`sse` 或 `streamable`（默认：`sse`）
- `PORT`: 服务端口（默认：`3033`）
- `ENDPOINT`: 端点路径
  - SSE 默认：`/sse`
  - Streamable 默认：`/mcp`

### MinIO 配置（可选）

如果需要使用 MinIO 对象存储，可以配置以下环境变量：

```yaml
environment:
  - MINIO_ENDPOINT=your-minio-endpoint
  - MINIO_PORT=9000
  - MINIO_USE_SSL=false
  - MINIO_ACCESS_KEY=your-access-key
  - MINIO_SECRET_KEY=your-secret-key
  - MINIO_BUCKET_NAME=mcp-echarts
```

## 端口映射

默认端口为 `3033`，如果需要使用其他端口，可以修改 `docker-compose.yml` 中的端口映射：

```yaml
ports:
  - "8080:3033"  # 将容器内的 3033 端口映射到主机的 8080 端口
```

## 健康检查

容器包含健康检查功能，可以通过以下命令查看：

```bash
docker ps
```

健康检查会定期访问服务端点，确保服务正常运行。

## 故障排查

1. **查看容器日志**

```bash
docker logs mcp-echarts
# 或使用 docker-compose
docker-compose logs mcp-echarts
```

2. **检查端口占用**

```bash
# Linux/Mac
netstat -tuln | grep 3033
# 或
lsof -i :3033

# Windows
netstat -ano | findstr :3033
```

3. **进入容器调试**

```bash
docker exec -it mcp-echarts sh
```

## 生产环境建议

1. **使用反向代理**：建议使用 Nginx 或 Traefik 作为反向代理，提供 HTTPS 支持
2. **资源限制**：在 `docker-compose.yml` 中添加资源限制：

```yaml
deploy:
  resources:
    limits:
      cpus: '1'
      memory: 512M
    reservations:
      cpus: '0.5'
      memory: 256M
```

3. **日志管理**：配置日志驱动，避免日志文件过大

```yaml
logging:
  driver: "json-file"
  options:
    max-size: "10m"
    max-file: "3"
```

