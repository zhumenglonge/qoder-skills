#!/bin/bash
# 用法: download.sh <B站链接或BV号> [输出目录，默认 ~/Desktop/赶月/music]
set -u
URL="${1:?用法: download.sh <B站链接或BV号> [输出目录]}"
OUT="${2:-$HOME/Desktop/赶月/music}"
mkdir -p "$OUT"

command -v yt-dlp >/dev/null 2>&1 || { echo "ERROR: yt-dlp 未安装，先运行: python3 -m pip install -U yt-dlp"; exit 1; }

FILE=""
for i in 1 2 3; do
  FILE=$(yt-dlp --no-playlist -f bestaudio --retries 15 --force-ipv4 --no-simulate \
    --print after_move:filepath -o "$OUT/%(title)s.%(ext)s" "$URL") && break
  echo "RETRY: 第 $i 次下载失败（B站 mcdn 镜像节点常见断连），重新解析地址并断点续传..."
done
if [ -z "$FILE" ] || [ ! -f "$FILE" ]; then
  echo "ERROR: 下载失败，已重试 3 次。可稍后再试，或检查链接是否需要登录。"
  exit 1
fi

if command -v ffprobe >/dev/null 2>&1; then
  ffprobe -v error -show_entries format=duration -show_entries stream=codec_name,sample_rate,channels \
    -of default=noprint_wrappers=1 "$FILE"
fi
echo "OK: $FILE"
