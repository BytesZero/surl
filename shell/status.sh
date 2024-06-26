#!/bin/bash
# 从 Cargo.toml 获取项目名称
PROJECT_NAME=$(grep '^name =' Cargo.toml | awk -F '"' '{print $2}')
# 查看服务状态
sudo systemctl status $PROJECT_NAME
# 查看日志
journalctl -u $PROJECT_NAME -f
