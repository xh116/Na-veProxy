FROM alpine:latest

ENV NAIVEPROXY_VERSION=v92.0.4515.107-1

RUN apk add --no-cache --virtual .build-deps \
     curl binutils \
    && curl --fail --silent -L https://github.com/klzgrad/naiveproxy/releases/download/${NAIVEPROXY_VERSION}/naiveproxy-${NAIVEPROXY_VERSION}-openwrt-x86_64.tar.xz|  \
      tar xJvf - -C / && mv naiveproxy-* naiveproxy  \
    && strip /naiveproxy/naive  \
    && mv /naiveproxy/naive /usr/local/bin/naive \
    && apk del .build-deps

RUN apk add --no-cache 
    
ENTRYPOINT [ "naive" ] 
CMD [ "config.json" ]
