# develop stage
FROM node:12.19.0-alpine3.12 as develop-stage
RUN apk update && apk add vim
RUN npm install -g http-server
WORKDIR /app
COPY source/package*.json ./
RUN npm install -g @vue/cli
RUN npm install
VOLUME /app/node_modules

# build stage
FROM develop-stage as build-stage
COPY source/ .
ENV VUE_APP_LOCATION container
RUN npm run build

# production stage
FROM nginx:1.15.7-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
COPY docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]