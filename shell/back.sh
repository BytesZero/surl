#!/bin/bash

# 从 Cargo.toml 获取项目名称
PROJECT_NAME=$(grep '^name =' Cargo.toml | awk -F '"' '{print $2}')

# 存在上一个版本上个版本
if [ -L "dist/${PROJECT_NAME}_prev" ]; then
  PREVIOUS_EXECUTABLE=$(readlink "dist/${PROJECT_NAME}_prev")
  ln -sf "$PREVIOUS_EXECUTABLE" "dist/${PROJECT_NAME}"
  # 查看文件链接情况
  ls -l dist/
  # 启动服务
  sudo systemctl restart $PROJECT_NAME
  # 判断是否有异常
  if [ $? -ne 0 ]; then
    echo -e "\033[31m 回滚出错 \033[0m"
    exit 1
  else
    # 回滚完成
    echo -e "\033[32m 项目回滚完成 \033[0m"
  fi

else
  echo -e "\033[31m 没有上一个版本 \033[0m"
fi
