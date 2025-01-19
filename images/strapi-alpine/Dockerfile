ARG NODE_VERSION=18
FROM node:${NODE_VERSION}-alpine AS base

WORKDIR /app

# 安装 Strapi CLI
RUN npm install -g @strapi/strapi@latest

RUN mkdir -p /srv/app && chown 1000:1000 -R /srv/app

WORKDIR /srv/app

VOLUME /srv/app

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod 777 /usr/local/bin/docker-entrypoint.sh && ln -s /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["strapi"]