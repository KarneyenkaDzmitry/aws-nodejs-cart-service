ARG NODE_VERSION=14

FROM node:$NODE_VERSION-alpine  as builder

WORKDIR /app

COPY . .

RUN npm install
RUN npm run build

FROM node:$NODE_VERSION-alpine

WORKDIR /app
COPY --from=builder /app/dist /app
COPY --from=builder /app/package.json /app/

RUN npm install --only=prod --no-audit --no-optional --no-package-lock
RUN npm ddp

USER node
EXPOSE 4000

CMD ["main.js"]
ENTRYPOINT ["node"] 