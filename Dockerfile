FROM node:22-alpine

WORKDIR /app

RUN npm install -g omniroute@3.8.50

# 复制并解压预置数据库
COPY storage.sqlite.gz /tmp/storage.sqlite.gz
RUN mkdir -p /root/.omniroute
RUN gunzip -c /tmp/storage.sqlite.gz > /root/.omniroute/storage.sqlite

# 清除旧密码，让 INITIAL_PASSWORD 生效
RUN apk add --no-cache sqlite && \
    sqlite3 /root/.omniroute/storage.sqlite "DELETE FROM key_value WHERE key = 'password';" || true

# 使用 Render 注入的 PORT
EXPOSE 10000
CMD sh -c "omniroute serve --port \${PORT:-10000} --no-open --log"
