ARG NODE_VERSION=18
FROM node:${NODE_VERSION}-alpine AS base

WORKDIR /app

# 安装 Strapi CLI
RUN npm install -g @strapi/strapi@latest

# 创建应用目录
RUN mkdir -p /srv/app && chown node:node -R /srv/app

VOLUME /srv/app

WORKDIR /srv/app

# 复制 package.json 和 package-lock.json，并安装生产依赖
COPY ./package.json ./package-lock.json* ./
RUN npm ci --only=production

# 复制应用代码
COPY . .


# 设置非 root 用户
USER node

# 暴露端口
EXPOSE 1337

# 设置入口点脚本
COPY ./docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["strapi"]