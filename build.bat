@echo off
REM MCP ECharts Docker 构建脚本 (Windows)

echo 开始构建 mcp-echarts Docker 镜像...

REM 构建镜像
docker build -t mcp-echarts:latest .

if %errorlevel% equ 0 (
    echo ✅ 镜像构建成功！
    echo.
    echo 运行以下命令启动容器：
    echo   docker run -d --name mcp-echarts -p 3033:3033 mcp-echarts:latest
    echo.
    echo 或使用 docker-compose：
    echo   docker-compose up -d
) else (
    echo ❌ 镜像构建失败！
    exit /b 1
)

