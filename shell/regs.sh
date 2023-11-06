#!/bin/bash

# 源文件路径
source_file="surl.service"

# 目标目录
target_dir="/etc/systemd/system/"

# 复制服务单元文件
cp $source_file $target_dir

# 重新加载 Systemd 配置
sudo systemctl daemon-reload

# 启用服务
sudo systemctl enable surl

# 打印成功注册,使用绿色字体
echo -e "\033[32mreg service success\033[0m"
