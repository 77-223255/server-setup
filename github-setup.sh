#!/bin/bash
# GitHub SSH 快速配置脚本
# 用于在新服务器上快速配置 Git 和 GitHub SSH 连接

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== GitHub SSH 配置脚本 ===${NC}\n"

# 检查是否已配置用户信息
read -p "请输入你的 GitHub 用户名: " github_username
read -p "请输入你的 GitHub 邮箱: " github_email

if [ -z "$github_username" ] || [ -z "$github_email" ]; then
    echo -e "${RED}错误: 用户名和邮箱不能为空${NC}"
    exit 1
fi

# 1. 配置 Git 用户信息
echo -e "${YELLOW}[1/5] 配置 Git 用户信息...${NC}"
git config --global user.name "$github_username"
git config --global user.email "$github_email"
echo -e "${GREEN}✓ Git 用户信息配置完成${NC}\n"

# 2. 检查是否已存在 SSH 密钥
if [ -f ~/.ssh/id_ed25519 ]; then
    echo -e "${YELLOW}警告: SSH 密钥已存在${NC}"
    read -p "是否覆盖现有密钥？(y/N): " overwrite
    if [ "$overwrite" != "y" ] && [ "$overwrite" != "Y" ]; then
        echo -e "${RED}已取消操作${NC}"
        exit 0
    fi
fi

# 3. 生成 SSH 密钥
echo -e "${YELLOW}[2/5] 生成 SSH 密钥对...${NC}"
mkdir -p ~/.ssh
chmod 700 ~/.ssh
ssh-keygen -t ed25519 -C "$github_email" -f ~/.ssh/id_ed25519 -N ""
echo -e "${GREEN}✓ SSH 密钥生成完成${NC}\n"

# 4. 启动 SSH agent 并添加密钥
echo -e "${YELLOW}[3/5] 配置 SSH agent...${NC}"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
echo -e "${GREEN}✓ SSH agent 配置完成${NC}\n"

# 5. 添加 GitHub 到已知主机
echo -e "${YELLOW}[4/5] 添加 GitHub 到已知主机列表...${NC}"
ssh-keyscan github.com >> ~/.ssh/known_hosts 2>/dev/null
echo -e "${GREEN}✓ GitHub 已添加到已知主机${NC}\n"

# 6. 显示公钥
echo -e "${YELLOW}[5/5] 显示 SSH 公钥${NC}"
echo -e "${GREEN}==================== 你的 SSH 公钥 ====================${NC}"
cat ~/.ssh/id_ed25519.pub
echo -e "${GREEN}=======================================================${NC}\n"

# 提示后续操作
echo -e "${YELLOW}下一步操作:${NC}"
echo "1. 复制上面显示的公钥（从 ssh-ed25519 开始到邮箱结束）"
echo "2. 访问 GitHub: ${GREEN}https://github.com/settings/keys${NC}"
echo "3. 点击 'New SSH key' 按钮"
echo "4. 粘贴公钥，给密钥起个名字（如：服务器名称）"
echo "5. 点击 'Add SSH key' 保存"
echo ""
echo -e "${YELLOW}完成后，运行以下命令测试连接:${NC}"
echo -e "${GREEN}ssh -T git@github.com${NC}"
echo ""
echo -e "${GREEN}配置完成！${NC}"
