#!/bin/sh
set -e

if [ $# -eq 0 ]; then
    set -- node dev/run-standalone.mjs
fi

if [ -n "$LITESTREAM_ACCESS_KEY_ID" ] && [ -n "$LITESTREAM_SECRET_ACCESS_KEY" ] && [ -n "$B2_BUCKET_NAME" ]; then
    echo "[Litestream] 正在从 Backblaze B2 恢复数据库（如果存在）..."
    litestream restore -if-replica-exists -config /etc/litestream.yml /data/storage.sqlite || true

    echo "[Litestream] 启动复制并运行 OmniRoute..."
    exec litestream replicate -config /etc/litestream.yml -exec "/app/check-permissions.sh $*"
else
    echo "[Litestream] 未配置 B2 凭证，将以无远程备份模式启动..."
    exec /app/check-permissions.sh "$@"
fi
