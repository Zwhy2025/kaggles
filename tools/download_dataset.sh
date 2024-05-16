#!/bin/bash
# 下载kaggle数据集

# global
TARGET_DIR="/kaggle/input"
# 定义数据集列表
data_sets=(
           "classify-leaves"
           "house-prices-advanced-regression-techniques"
           )
# function
# 一个函数，可以打印输出带有时间戳的日志
function log() {
    echo "$(date +'[%Y-%m-%d %H:%M:%S]') $1"
}

# 判断目录是否存在，如果不存在则创建
function check_dir() {
    if [ ! -d "$1" ]; then
        log "目录 $1 不存在。创建它..."
        sudo mkdir -p  "$1"
        sudo chmod 707 "$1"
    fi
}

# 定义函数 download_and_extract
function download_and_extract() {
    local competition_name=$1
    local competition_zip="${competition_name}.zip"
    local unzip_dir="${competition_name}"
    # 下载比赛数据
    log "正在下载${competition_name}数据..."
    kaggle competitions download -c "${competition_name}" || {
        log "下载${competition_name}数据失败，请检查Kaggle API密钥和网络连接。"
        return 1
    }
    # 解压文件到指定目录
    if [ -d "${unzip_dir}" ]; then
        log "目标目录${unzip_dir}已存在，将删除旧文件..."
        rm -rf "${unzip_dir}" || {
            log "删除${unzip_dir}失败，请检查文件权限。"
            return 1
        }
    fi
    log "正在解压${competition_name}文件..."
    unzip -q "${competition_zip}"  -d "${unzip_dir}" || {
        log "解压${competition_name}文件失败，请检查文件是否完整或是否有权限问题。"
        return 1
    }
    # 删除压缩文件
    log "正在删除${competition_name}压缩文件..."
    rm "${competition_zip}" || {
        log "删除${competition_name}压缩文件失败，请检查文件权限。"
        return 1
    }
    log "所有${competition_name}操作完成。"
}

# main
log "------------------ begin ------------------"

log "检查数据集目录{$TARGET_DIR}是否存在"
check_dir $TARGET_DIR
cd $TARGET_DIR || exit
log "开始下载数据集"
# 遍历数据集列表并调用函数
for dataset in "${data_sets[@]}"; do
    download_and_extract "$dataset"
done


log "------------------ end ------------------"