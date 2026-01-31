# server-setup

这是一个用于快速配置新服务器与 GitHub 连接的工具仓库。

## 仓库描述

当你需要在新的服务器（Linux/Windows）上配置 Git 和 GitHub SSH 连接时，本仓库提供了自动化脚本，帮助你快速完成以下任务：

- 配置 Git 用户信息
- 生成 SSH 密钥对
- 配置 SSH agent
- 添加 GitHub 到已知主机列表

## 使用方法

### 1. 克隆仓库

```bash
git clone git@github.com:77-223255/o配置.git
cd o配置
```

### 2. 运行配置脚本

```bash
chmod +x github-setup.sh
./github-setup.sh
```

### 3. 添加公钥到 GitHub

脚本运行后会显示你的 SSH 公钥，请将其添加到 GitHub：

1. 访问 https://github.com/settings/keys
2. 点击 **New SSH key**
3. 粘贴公钥内容
4. 保存

### 4. 测试连接

```bash
ssh -T git@github.com
```

如果看到 `Hi [你的用户名]! You've successfully authenticated...` 说明配置成功！

## 注意事项

- 运行脚本前，请先编辑 `github-setup.sh`，填入你的 GitHub 用户名和邮箱
- SSH 私钥会保存在 `~/.ssh/id_ed25519`，请妥善保管
- 每台新服务器建议生成新的 SSH 密钥对，以提高安全性

## 文件说明

- `github-setup.sh` - GitHub SSH 配置自动化脚本
- `README.md` - 本说明文档

## 系统要求

- Git 2.0+
- OpenSSH
- Bash shell

## 许可证

MIT License
