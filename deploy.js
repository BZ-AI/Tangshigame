// GitHub部署脚本
const { execSync } = require('child_process');
const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// 颜色输出函数
const colors = {
  reset: '\x1b[0m',
  bright: '\x1b[1m',
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  cyan: '\x1b[36m'
};

function log(message, color = '') {
  console.log(`${color}${message}${colors.reset}`);
}

function executeCommand(command) {
  try {
    log(`执行: ${command}`, colors.cyan);
    return execSync(command, { encoding: 'utf8' });
  } catch (error) {
    log(`命令执行失败: ${error.message}`, colors.red);
    process.exit(1);
  }
}

function initRepo() {
  // 检查是否已初始化git仓库
  try {
    execSync('git status', { stdio: 'ignore' });
    log('Git仓库已存在', colors.green);
  } catch (error) {
    log('正在初始化Git仓库...', colors.yellow);
    executeCommand('git init');
  }
}

function deployToGitHub(repoUrl, branch) {
  log('\n===== 开始部署到GitHub =====', colors.bright + colors.yellow);
  
  // 初始化Git仓库
  initRepo();
  
  // 检查远程仓库是否已配置
  const remotes = executeCommand('git remote -v').trim();
  if (!remotes.includes('origin')) {
    log('添加远程仓库...', colors.yellow);
    executeCommand(`git remote add origin ${repoUrl}`);
  } else {
    log('远程仓库已配置', colors.green);
  }

  // 添加所有文件
  log('添加文件到Git...', colors.yellow);
  executeCommand('git add .');
  
  // 提交更改
  const timestamp = new Date().toLocaleString('zh-CN');
  log('提交更改...', colors.yellow);
  executeCommand(`git commit -m "更新于 ${timestamp}"`);
  
  // 推送到GitHub
  log(`推送到GitHub (${branch})...`, colors.yellow);
  executeCommand(`git push -u origin ${branch}`);
  
  log('\n✅ 部署成功！', colors.bright + colors.green);
  log(`仓库地址: ${repoUrl}`, colors.green);
}

function startDeploy() {
  log('唐诗三百首策略游戏 - GitHub部署工具', colors.bright + colors.blue);
  log('----------------------------\n', colors.blue);
  
  rl.question('请输入GitHub仓库URL (例如: https://github.com/username/repo.git): ', (repoUrl) => {
    if (!repoUrl) {
      log('错误: 仓库URL不能为空', colors.red);
      rl.close();
      return;
    }
    
    rl.question('请输入分支名称 (默认: main): ', (branch) => {
      branch = branch || 'main';
      
      log('\n准备部署项目到GitHub...\n', colors.yellow);
      deployToGitHub(repoUrl, branch);
      rl.close();
    });
  });
}

// 开始部署流程
startDeploy(); 