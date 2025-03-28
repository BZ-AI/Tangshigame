#!/bin/bash
# 唐诗三百首策略游戏 - GitHub一键部署工具
# Linux/macOS版本 - 无需Node.js

# 颜色输出定义
RESET="\033[0m"
BOLD="\033[1m"
RED="\033[31m"
GREEN="\033[32m"
YELLOW="\033[33m"
BLUE="\033[34m"
CYAN="\033[36m"

# 输出带颜色文本
print_color() {
  echo -e "${1}${2}${RESET}"
}

echo
print_color "${BOLD}${CYAN}" "===== 唐诗三百首策略游戏 - GitHub部署工具 ====="
print_color "${CYAN}" "-------------------------------------------"
echo

# 检查Git是否已安装
if ! command -v git &> /dev/null; then
  print_color "${BOLD}${RED}" "错误: 未检测到Git。请先安装Git:"
  print_color "${RED}" "Linux: sudo apt install git 或 sudo yum install git"
  print_color "${RED}" "macOS: brew install git 或通过Xcode安装"
  exit 1
fi

print_color "${GREEN}" "Git已安装，开始准备部署..."
echo

# 输入仓库URL
read -p "请输入GitHub仓库URL (例如: https://github.com/username/repo.git): " repo_url
if [ -z "$repo_url" ]; then
  print_color "${RED}" "错误: 仓库URL不能为空"
  exit 1
fi

# 输入分支名称
read -p "请输入分支名称 (默认: main): " branch
branch=${branch:-main}

echo
print_color "${BOLD}${YELLOW}" "===== 开始部署到GitHub ====="
echo

# 检查是否已初始化Git仓库
if [ ! -d .git ]; then
  print_color "${YELLOW}" "正在初始化Git仓库..."
  git init
else
  print_color "${GREEN}" "Git仓库已存在"
fi

# 检查远程仓库是否已配置
if ! git remote -v | grep -q "origin"; then
  print_color "${YELLOW}" "添加远程仓库..."
  git remote add origin "$repo_url"
else
  print_color "${GREEN}" "远程仓库已配置"
fi

# 添加所有文件
print_color "${YELLOW}" "添加文件到Git..."
git add .

# 提交更改
print_color "${YELLOW}" "提交更改..."
timestamp=$(date "+%Y-%m-%d %H:%M:%S")
git commit -m "更新于 $timestamp"

# 推送到GitHub
print_color "${YELLOW}" "推送到GitHub ($branch)..."
if git push -u origin "$branch"; then
  echo
  print_color "${BOLD}${GREEN}" "✅ 部署成功！"
  print_color "${GREEN}" "仓库地址: $repo_url"
  echo
  print_color "${YELLOW}" "如需在网页上查看项目，请执行以下步骤:"
  echo " 1. 访问GitHub仓库页面"
  echo " 2. 进入\"Settings\" -> \"Pages\""
  echo " 3. 在\"Source\"部分，选择你部署的分支（$branch）"
  echo " 4. 点击\"Save\"保存设置"
  echo " 5. 等待几分钟，你的游戏将会发布"
else
  echo
  print_color "${RED}" "推送失败。请检查GitHub凭据和仓库访问权限。"
  print_color "${YELLOW}" "可能需要输入GitHub用户名和密码，或设置SSH密钥。"
fi

echo
read -p "按回车键继续..." dummy 