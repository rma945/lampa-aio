ARG ALPINE_VERSION=3.22.1
ARG LAMPA_VERSION=369faab3c096535da89e656fe4b154e788733ed7

FROM alpine:${ALPINE_VERSION}

ARG LAMPA_VERSION
ENV LAMPA_VERSION="${LAMPA_VERSION}" \
    LAMPA_CONFIG_PATH=/www/config.json

LABEL maintainer="rma945" \
    org.opencontainers.image.title="Lampa AIO" \
    org.opencontainers.image.description="Lampa - All in One" \
    org.opencontainers.image.revision="${LAMPA_VERSION}"

RUN apk add --no-cache nginx
RUN wget https://codeload.github.com/yumata/lampa/zip/${LAMPA_VERSION} -O lampa.zip &&\
    unzip lampa.zip && mv lampa-${LAMPA_VERSION} /www/ && rm -rf lampa.zip &&\
    chown -R nginx:nginx /www/ &&\
    # Inject auto-config script into index.html
    sed -i '/<script src=".\/vender\/keypad\/keypad.js"><\/script>/a <script src=".\/auto-config.js"><\/script>' /www/index.html

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY --chown=nginx:nginx --chmod=640 conf/config.json /www/
COPY --chown=nginx:nginx --chmod=640 conf/auto-config.js /www/
COPY --chown=nginx:nginx --chmod=550 conf/entrypoint.sh /entrypoint.sh

USER nginx:nginx

EXPOSE 8080/tcp

WORKDIR /www/
ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx"]
