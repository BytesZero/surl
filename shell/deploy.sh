#!/bin/bash
# 从 Cargo.toml 获取项目名称
PROJECT_NAME=$(grep '^name =' Cargo.toml | awk -F '"' '{print $2}')
# 拉最新的代码
git pull
# 构建版本
sh shell/build.sh
# 启动服务
sudo systemctl restart $PROJECT_NAME

# 判断是否有异常
if [ $? -ne 0 ]; then
    echo -e "\033[31m start error \033[0m"
    exit 1
else
    # 打印成功启动,使用绿色字体
    echo -e "\033[32m start success \033[0m"
    # 查看服务状态
    sudo systemctl status $PROJECT_NAME
fi
