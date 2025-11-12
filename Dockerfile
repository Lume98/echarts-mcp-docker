# 使用官方 Node.js 运行时作为基础镜像
FROM node:20-alpine

# 安装 wget 用于健康检查
RUN apk add --no-cache wget

# 设置工作目录
WORKDIR /app

# 安装 mcp-echarts 全局包
RUN npm install -g mcp-echarts

# 暴露默认端口
EXPOSE 3033

# 设置环境变量（可选，用于 MinIO 配置）
# 可以通过 docker-compose 或运行时环境变量覆盖
ENV TRANSPORT=sse
ENV PORT=3033
ENV ENDPOINT=/sse

# 健康检查
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost:3033/sse 2>/dev/null || exit 1

# 启动 mcp-echarts 服务器
# 使用 SSE 传输方式，可以通过环境变量修改
CMD sh -c "mcp-echarts -t ${TRANSPORT} -p ${PORT} -e ${ENDPOINT}"

