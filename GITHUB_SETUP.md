# GitHub Actions 配置指南

本文档说明如何在 GitHub 上配置自动构建 Docker 镜像所需的所有设置。

## 📋 配置概览

根据你的需求，配置分为两种：

1. **基础配置（推荐）**：仅使用 GitHub Container Registry (ghcr.io) - **无需额外配置**
2. **完整配置（可选）**：同时推送到 Docker Hub - 需要配置 Secrets

---

## ✅ 基础配置：GitHub Container Registry

### 自动配置

GitHub Container Registry (ghcr.io) **无需任何手动配置**！工作流会自动：

- 使用 `GITHUB_TOKEN`（GitHub 自动提供）
- 推送到 `ghcr.io/<your-username>/<repo-name>`
- 镜像会出现在仓库的 **Packages** 标签页

### 设置包可见性（可选）

首次推送后，你可能需要设置包的可见性：

1. 进入仓库页面
2. 点击右侧的 **Packages** 区域（或访问 `https://github.com/<username>/<repo-name>/pkgs/container/<repo-name>`）
3. 点击包名称进入包详情页
4. 点击 **Package settings**
5. 在 **Danger Zone** 中可以选择：
   - **Change visibility**：将包设为公开或私有
   - **Delete package**：删除包（如果需要）

### 使用镜像

```bash
# 拉取镜像（如果包是公开的）
docker pull ghcr.io/<your-username>/<repo-name>:latest

# 如果包是私有的，需要先登录
echo $GITHUB_TOKEN | docker login ghcr.io -u <your-username> --password-stdin
docker pull ghcr.io/<your-username>/<repo-name>:latest
```

---

## 🔧 完整配置：同时推送到 Docker Hub

如果你希望镜像同时推送到 Docker Hub，需要配置以下 Secrets。

### 步骤 1：创建 Docker Hub 访问令牌

1. 登录 [Docker Hub](https://hub.docker.com/)
2. 点击右上角头像 → **Account Settings**
3. 左侧菜单选择 **Security**
4. 点击 **New Access Token**
5. 输入 Token 描述（如：`GitHub Actions`）
6. 选择权限：**Read & Write** 或 **Read, Write & Delete**
7. 点击 **Generate**
8. **复制生成的 Token**（只显示一次，请妥善保存）

### 步骤 2：在 GitHub 仓库中添加 Secrets

1. 进入你的 GitHub 仓库
2. 点击 **Settings**（设置）
3. 左侧菜单选择 **Secrets and variables** → **Actions**
4. 点击 **New repository secret** 按钮
5. 添加以下两个 Secrets：

#### Secret 1: `DOCKERHUB_USERNAME`
- **Name**: `DOCKERHUB_USERNAME`
- **Secret**: 你的 Docker Hub 用户名

#### Secret 2: `DOCKERHUB_TOKEN`
- **Name**: `DOCKERHUB_TOKEN`
- **Secret**: 刚才复制的 Docker Hub 访问令牌

### 步骤 3：验证配置

配置完成后，下次推送到 `main` 分支时，工作流会：

1. 自动推送到 GitHub Container Registry
2. 同时推送到 Docker Hub（`<your-dockerhub-username>/mcp-echarts`）

你可以在 **Actions** 标签页查看构建日志确认。

---

## 🔍 验证配置是否生效

### 方法 1：查看 Actions 日志

1. 进入仓库的 **Actions** 标签页
2. 点击最新的工作流运行
3. 查看构建日志，应该看到：
   - ✅ "Log in to GitHub Container Registry" 成功
   - ✅ "Log in to Docker Hub" 成功（如果配置了）
   - ✅ "Build and push Docker image" 成功

### 方法 2：检查镜像是否存在

**GitHub Container Registry:**
- 访问：`https://github.com/<username>/<repo-name>/pkgs/container/<repo-name>`
- 或在仓库页面查看右侧的 **Packages** 区域

**Docker Hub:**
- 访问：`https://hub.docker.com/r/<your-dockerhub-username>/mcp-echarts`
- 或使用命令：`docker search <your-dockerhub-username>/mcp-echarts`

---

## ⚠️ 常见问题

### Q1: 为什么我的镜像在 ghcr.io 上是私有的？

**A:** 默认情况下，GitHub Container Registry 的包是私有的。你需要手动设置为公开：
1. 进入包的设置页面
2. 在 **Danger Zone** 中选择 **Change visibility**
3. 选择 **Public**

### Q2: 如何删除旧的镜像？

**A:** 
- **GitHub Container Registry**: 在包的设置页面可以删除版本
- **Docker Hub**: 在 Docker Hub 的仓库页面可以删除标签

### Q3: 工作流失败了，提示权限不足？

**A:** 检查以下几点：
1. 确保仓库的 **Settings** → **Actions** → **General** → **Workflow permissions** 设置为：
   - ✅ **Read and write permissions**
   - ✅ **Allow GitHub Actions to create and approve pull requests**
2. 如果使用 Docker Hub，确保 Secrets 配置正确

### Q4: 如何手动触发构建？

**A:** 
1. 进入 **Actions** 标签页
2. 选择 **Build and Push Docker Image** 工作流
3. 点击 **Run workflow** 按钮
4. 选择分支并点击 **Run workflow**

---

## 📝 总结

### 最小配置（推荐）
- ✅ **无需任何配置**，直接推送代码即可
- ✅ 镜像会自动推送到 `ghcr.io/<username>/<repo-name>`

### 完整配置（可选）
- ✅ 配置 `DOCKERHUB_USERNAME` Secret
- ✅ 配置 `DOCKERHUB_TOKEN` Secret
- ✅ 镜像会同时推送到 GitHub Container Registry 和 Docker Hub

---

## 🔗 相关链接

- [GitHub Container Registry 文档](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-container-registry)
- [Docker Hub 文档](https://docs.docker.com/docker-hub/)
- [GitHub Actions 文档](https://docs.github.com/en/actions)

