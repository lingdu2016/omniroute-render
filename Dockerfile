FROM diegosouzapw/omniroute:3.8.50

# Instala o Litestream para streaming contínuo do SQLite para o Cloudflare R2
ADD https://github.com/benbjohnson/litestream/releases/download/v0.3.13/litestream-v0.3.13-linux-amd64.tar.gz /tmp/litestream.tar.gz
USER root
RUN tar -C /usr/local/bin -xzf /tmp/litestream.tar.gz && rm /tmp/litestream.tar.gz

COPY litestream.yml /etc/litestream.yml
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Garante permissões no diretório de dados
RUN mkdir -p /data && chown -R node:node /data 2>/dev/null || true

ENTRYPOINT ["/entrypoint.sh"]
