FROM node:25.0.0-alpine3.22 AS builder

ARG LAMPA_GIT_URL="https://github.com/rma945/lampa-source"
ARG LAMPA_GIT_REF="feat/add-torrs-parser"
ENV LAMPA_GIT_URL="${LAMPA_GIT_URL}" \
    LAMPA_GIT_REF="${LAMPA_GIT_REF}"

RUN apk add --no-cache git

WORKDIR /src
RUN git clone --single-branch --branch "${LAMPA_GIT_REF}" "${LAMPA_GIT_URL}" . && \
    npm install &&\
    sed -i 's|parallel(watch, browser_sync)|series(merge, plugins, sass_task, lang_task, sync_web, build_web)|' gulpfile.js &&\
    npx gulp && npx gulp

FROM alpine:3.22.1 AS final

LABEL maintainer="rma945" \
      org.opencontainers.image.title="Lampa AIO" \
      org.opencontainers.image.description="Lampa - All in One"

ENV LAMPA_CONFIG_PATH='/www/config.json'

RUN apk add --no-cache nginx && mkdir /www/

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY --chown=nginx:nginx --chmod=640 conf/config.json /www/
COPY --chown=nginx:nginx --chmod=640 conf/auto-config.js /www/
COPY --chown=nginx:nginx plugins /www/plugins
COPY --chown=nginx:nginx --chmod=550 conf/entrypoint.sh /entrypoint.sh
COPY --chown=nginx:nginx --from=builder /src/build/web/ /www/

# Inject auto-config script into index.html
RUN sed -i '/<script src=".\/vender\/keypad\/keypad.js"><\/script>/a <script src=".\/auto-config.js"><\/script>' /www/index.html

USER nginx:nginx

WORKDIR /www/
EXPOSE 8080/tcp

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx"]
