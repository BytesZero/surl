#!/bin/bash
# 从 Cargo.toml 获取项目名称
PROJECT_NAME=$(grep '^name =' Cargo.toml | awk -F '"' '{print $2}')
# 停止服务
sudo systemctl stop $PROJECT_NAME

# 判断是否有异常
if [ $? -ne 0 ]; then
  echo -e "\033[31m 服务停止出错 \033[0m"
  exit 1
else
  # 提示安装成功
  echo -e "\033[32m 服务停止成功 \033[0m"
fi
# 查看服务状态
sudo systemctl status $PROJECT_NAME
# 查看日志
journalctl -u $PROJECT_NAME -f
