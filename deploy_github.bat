@echo off
:: 唐诗三百首策略游戏 - GitHub一键部署工具
:: Windows批处理版本 - 无需Node.js

echo.
echo [1;36m===== 唐诗三百首策略游戏 - GitHub部署工具 =====[0m
echo [1;36m-------------------------------------------[0m
echo.

:: 检查Git是否已安装
git --version > nul 2>&1
if %errorlevel% neq 0 (
    echo [1;31m错误: 未检测到Git。请先安装Git: https://git-scm.com/downloads[0m
    pause
    exit /b
)

echo [1;32mGit已安装，开始准备部署...[0m
echo.

:: 输入仓库URL
set /p repo_url=请输入GitHub仓库URL (例如: https://github.com/username/repo.git): 
if "%repo_url%"=="" (
    echo [1;31m错误: 仓库URL不能为空[0m
    pause
    exit /b
)

:: 输入分支名称
set /p branch=请输入分支名称 (默认: main): 
if "%branch%"=="" set branch=main

echo.
echo [1;33m===== 开始部署到GitHub =====[0m
echo.

:: 检查是否已初始化Git仓库
if not exist .git (
    echo [1;33m正在初始化Git仓库...[0m
    git init
) else (
    echo [1;32mGit仓库已存在[0m
)

:: 检查远程仓库是否已配置
git remote -v | findstr "origin" > nul
if %errorlevel% neq 0 (
    echo [1;33m添加远程仓库...[0m
    git remote add origin %repo_url%
) else (
    echo [1;32m远程仓库已配置[0m
)

:: 添加所有文件
echo [1;33m添加文件到Git...[0m
git add .

:: 提交更改
echo [1;33m提交更改...[0m
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mm=%%a& set dd=%%b& set yy=%%c)
for /f "tokens=1-2 delims=: " %%a in ('time /t') do (set hh=%%a& set mn=%%b)
git commit -m "更新于 %yy%-%mm%-%dd% %hh%:%mn%"

:: 推送到GitHub
echo [1;33m推送到GitHub (%branch%)...[0m
git push -u origin %branch%

if %errorlevel% neq 0 (
    echo.
    echo [1;31m推送失败。请检查GitHub凭据和仓库访问权限。[0m
    echo [1;33m可能需要输入GitHub用户名和密码，或设置SSH密钥。[0m
) else (
    echo.
    echo [1;32m✅ 部署成功！[0m
    echo [1;32m仓库地址: %repo_url%[0m
    echo.
    echo [1;33m如需在网页上查看项目，请执行以下步骤:[0m
    echo  1. 访问GitHub仓库页面
    echo  2. 进入"Settings" -^> "Pages"
    echo  3. 在"Source"部分，选择你部署的分支（%branch%）
    echo  4. 点击"Save"保存设置
    echo  5. 等待几分钟，你的游戏将会发布
)

echo.
pause 