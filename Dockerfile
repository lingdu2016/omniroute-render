FROM node:22-alpine

WORKDIR /app

RUN npm install -g omniroute@3.8.50

COPY storage.sqlite.gz /tmp/storage.sqlite.gz
RUN mkdir -p /root/.omniroute
RUN gunzip -c /tmp/storage.sqlite.gz > /root/.omniroute/storage.sqlite

# 清除旧密码
RUN apk add --no-cache sqlite && \
    sqlite3 /root/.omniroute/storage.sqlite "DELETE FROM key_value WHERE key = 'password';" || true

ENV NODE_ENV=production
ENV HOSTNAME=0.0.0.0
ENV PORT=10000

EXPOSE 10000

CMD ["sh", "-c", "omniroute serve --port $PORT --no-open --log"]
