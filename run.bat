@echo off
REM MCP ECharts Docker 运行脚本 (Windows)

REM 检查镜像是否存在
docker images | findstr "mcp-echarts" >nul
if %errorlevel% neq 0 (
    echo 镜像不存在，正在构建...
    call build.bat
    if %errorlevel% neq 0 exit /b 1
)

REM 停止并删除已存在的容器
docker ps -a | findstr "mcp-echarts" >nul
if %errorlevel% equ 0 (
    echo 停止并删除已存在的容器...
    docker stop mcp-echarts 2>nul
    docker rm mcp-echarts 2>nul
)

REM 运行容器
echo 启动 mcp-echarts 容器...
docker run -d ^
    --name mcp-echarts ^
    -p 3033:3033 ^
    -e TRANSPORT=sse ^
    -e PORT=3033 ^
    -e ENDPOINT=/sse ^
    --restart unless-stopped ^
    mcp-echarts:latest

if %errorlevel% equ 0 (
    echo ✅ 容器启动成功！
    echo.
    echo 服务地址：
    echo   SSE: http://localhost:3033/sse
    echo.
    echo 查看日志：
    echo   docker logs -f mcp-echarts
    echo.
    echo 停止容器：
    echo   docker stop mcp-echarts
) else (
    echo ❌ 容器启动失败！
    exit /b 1
)

