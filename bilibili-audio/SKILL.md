---
name: bilibili-audio
description: 下载 Bilibili（B站）视频的原始音质音频，不转码。当用户给出 bilibili.com 链接或 BV 号，要求下载音频、提取视频里的音乐/歌曲、扒歌时使用。
---

# B站音频下载

## 概述

用 yt-dlp 抽取 B 站视频的最高音质音频流（通常为 m4a/AAC），保持原始音质，不做任何转码。默认保存到 `~/Desktop/赶月/music`，文件名为视频标题。

## 前置检查

确认 yt-dlp 可用（`command -v yt-dlp`）。未安装则运行：

```bash
python3 -m pip install -U yt-dlp
```

## 下载

运行本 skill 目录下的脚本（路径相对本 SKILL.md 所在目录）：

```bash
bash scripts/download.sh "<B站链接>" [输出目录]
```

- 链接中的跟踪参数（spm_id_from、vd_source 等）无需清理，直接传入即可。
- 脚本自动选最高音质音频流（`-f bestaudio`），自动处理多P视频（只下当前分P）。
- 成功时输出 `OK: <文件绝对路径>` 及 ffprobe 验证信息（时长、编码、采样率）。

## 已知问题与对策

- **mcdn 镜像断连**：B 站会分配 P2P 镜像节点（`*.mcdn.bilivideo.cn`），经常 connection reset / read timeout。脚本已内置 3 轮整体重试，每轮重新解析地址（换节点）并断点续传，通常第 2 轮即成功。若 3 轮全失败，告知用户稍后再试。
- **需要登录的内容**：普通视频的音频无需登录。若脚本提示需要 cookies（大会员专属内容），向用户说明并询问是否提供浏览器 cookies（`--cookies-from-browser`），不要自行绕过。
- **指定分P**：多P视频默认下 P1；用户指定某一P时，在链接后加 `?p=N`。

## 交付

完成后用 file:// 绝对路径链接把音频文件给用户，附时长和音质信息。不要主动转 mp3——用户要求保持原始音质；仅当用户明确要求其他格式时才用 ffmpeg 转换。
