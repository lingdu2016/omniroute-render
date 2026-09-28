FROM node:22-alpine

WORKDIR /app

# 构建期需要编译工具时再放开；你这次能装上可先不加
# RUN apk add --no-cache python3 make g++

RUN npm install -g omniroute@3.8.50

COPY storage.sqlite.gz /tmp/storage.sqlite.gz
RUN mkdir -p /root/.omniroute \
 && gunzip -c /tmp/storage.sqlite.gz > /root/.omniroute/storage.sqlite \
 && rm -f /tmp/storage.sqlite.gz

RUN apk add --no-cache sqlite \
 && sqlite3 /root/.omniroute/storage.sqlite "DELETE FROM key_value WHERE key = 'password';" || true

ENV NODE_ENV=production
ENV PORT=10000
# 关键不要用 HOSTNAME，shell 会覆盖；用这个
ENV OMNIROUTE_SERVER_HOST=0.0.0.0
ENV DATA_DIR=/root/.omniroute
# 免费档内存紧时建议加上
ENV OMNIROUTE_MEMORY_MB=512
ENV NODE_OPTIONS=--max-old-space-size=512

EXPOSE 10000

CMD ["sh", "-c", "omniroute serve --port ${PORT} --no-open --log"]
