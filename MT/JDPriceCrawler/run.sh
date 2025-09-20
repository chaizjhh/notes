#!/bin/bash

# 获取脚本所在目录
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# JAR 文件名
JAR_FILE="JDPriceCrawler-1.0.jar"

# 检查 JAR 文件是否存在
if [ ! -f "$DIR/$JAR_FILE" ]; then
    echo "错误：$JAR_FILE 不存在。请确保已经构建了项目。"
    exit 1
fi

# 运行 JAR 文件
java -jar "$DIR/$JAR_FILE"