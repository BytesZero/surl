#!/bin/bash
# 从 Cargo.toml 获取项目名称
PROJECT_NAME=$(grep '^name =' Cargo.toml | awk -F '"' '{print $2}')
# 源文件路径
source_file="shell/${PROJECT_NAME}.service"

# 目标目录
target_dir="/etc/systemd/system/"

# 复制服务单元文件
cp $source_file $target_dir

# 重新加载 Systemd 配置
sudo systemctl daemon-reload

# 启用服务
sudo systemctl enable $PROJECT_NAME

# 判断是否有异常
if [ $? -ne 0 ]; then
  echo -e "\033[31m 服务注册出错 \033[0m"
  exit 1
else
  # 提示安装成功
  echo -e "\033[32m 服务注册成功 \033[0m"
fi
