#!/bin/bash

# 从 Cargo.toml 获取项目名称和版本号
PROJECT_NAME=$(grep '^name =' Cargo.toml | awk -F '"' '{print $2}')
PROJECT_VERSION=$(grep '^version =' Cargo.toml | awk -F '"' '{print $2}')

# 编译项目
cargo build --release

# 创建目标目录（如果不存在）
mkdir -p dist

# 创建上个版本
if [ -L "dist/${PROJECT_NAME}" ]; then
  PREVIOUS_EXECUTABLE=$(readlink "dist/${PROJECT_NAME}")
  if [[ "$PREVIOUS_EXECUTABLE" != *"$PROJECT_VERSION"* ]]; then
    ln -sf "$PREVIOUS_EXECUTABLE" "dist/${PROJECT_NAME}_prev"
  else
    echo -e "\033[31m 没有新版本,回滚版本不变 \033[0m"
  fi
fi

# 生成带版本号的可执行文件名
EXECUTABLE_NAME="${PROJECT_NAME}_v${PROJECT_VERSION}"

# 复制并重命名可执行文件
cp "target/release/$PROJECT_NAME" "dist/$EXECUTABLE_NAME"

# 创建或更新符号链接，指向最新版本
ln -sf "$EXECUTABLE_NAME" "dist/$PROJECT_NAME"


# 查看文件链接情况
ls -l dist/

# 判断是否有异常
if [ $? -ne 0 ]; then
  echo -e "\033[31m 编译出错 \033[0m"
  exit 1
else
  # 构建完成
  echo -e "\033[32m 构建编译完成在: dist/${PROJECT_NAME} -> dist/$EXECUTABLE_NAME \033[0m"
fi

# 清理项目
cargo clean
