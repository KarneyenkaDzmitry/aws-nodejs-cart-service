FROM node:10-alpine  as builder

ENV MAINTAINER=DzmitryKarneyenka
ENV CUSTOM=DzmitryKarneyenka

WORKDIR /app

COPY package.json ./
RUN npm install --no-audit --no-optional --no-package-lock

COPY . .
RUN npm run build

FROM builder as middle

WORKDIR /app
RUN npm prune --production --no-package-lock

FROM node:10-alpine  as production

WORKDIR /app

COPY --from=builder /app/dist .
COPY --from=middle /app/node_modules /app/node_modules

USER node
ENV PORT=8080
EXPOSE 8080

ENTRYPOINT ["node", "main.js"] 