#!/bin/bash
sudo systemctl stop surl
# 打印成功停止,使用绿色字体
echo -e "\033[32mstop success\033[0m"
# 查看服务状态
sudo systemctl status surl