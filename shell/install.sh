#!/bin/bash
#安装 rust 环境
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# 刷新环境变量
source $HOME/.cargo/env
# 提示安装成功
echo -e "\033[32minstall success\033[0m"
# 注册服务
./regs.sh
# 启动服务
./start.sh