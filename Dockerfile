# ARG NODE_VERSION=14
# ARG IMAGE=node:${NODE_VERSION}-alpine
# ARG IMAGE=node:14-alpine

FROM node:14-alpine  as builder

ENV MAINTAINER=DzmitryKarneyenka
ENV CUSTOM=DzmitryKarneyenka

WORKDIR /app

COPY package.json ./
RUN npm install --no-audit --no-optional --no-package-lock

COPY . .
RUN npm run build

FROM node:14-alpine as middle

WORKDIR /app

COPY package.json ./
RUN npm install --only=prod --no-audit --no-optional --no-package-lock

FROM node:14-alpine  as production

WORKDIR /app

COPY --from=builder /app/dist .
COPY --from=middle /app/node_modules /app/node_modules

USER node
EXPOSE 4000

ENTRYPOINT ["node", "main.js"] 