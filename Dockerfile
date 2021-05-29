FROM alpine:latest

ENV NAIVEPROXY_VERSION=v91.0.4472.77-1

RUN apk add --no-cache --virtual .build-deps \
     curl binutils \
    && curl --fail --silent -L https://github.com/klzgrad/naiveproxy/releases/download/${NAIVEPROXY_VERSION}/naiveproxy-${NAIVEPROXY_VERSION}-openwrt-x86_64.tar.xz| \
      tar xJvf - -C / && mv naiveproxy-* naiveproxy  \
    && strip /naiveproxy/naive  \
    && mv /naiveproxy/naive /usr/local/bin/naive \
    && apk del .build-deps

RUN apk add --no-cache libstdc++ 
    
ENTRYPOINT [ "naive" ] 
CMD [ "config.json" ]
