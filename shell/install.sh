#!/bin/bash
#安装 rust 环境
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# 刷新环境变量
source $HOME/.cargo/env
# 判断是否有异常
if [ $? -ne 0 ]; then
  echo -e "\033[31m 安装出错 \033[0m"
  exit 1
else
  # 提示安装成功
  echo -e "\033[32m 安装成功 \033[0m"
fi
# 注册服务
./regs.sh
# 启动服务
./start.sh