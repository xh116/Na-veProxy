FROM alpine:latest

ENV NAIVEPROXY_VERSION=v90.0.4430.85-10

RUN apk add --no-cache --virtual .build-deps \
    curl binutils \
    && curl --fail --silent -L https://github.com/klzgrad/naiveproxy/releases/download/${NAIVEPROXY_VERSION}/naiveproxy-${NAIVEPROXY_VERSION}-openwrt-x86_64.tar.xz| \
      tar xJvf - -C / \
    && mv /naiveproxy-${NAIVEPROXY_VERSION}-openwrt-x86_64/naive /usr/local/bin/naive
    && apk del .build-deps
 
ENTRYPOINT [ "naive" ]
CMD [ "config.json" ]
