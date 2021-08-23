FROM alpine:latest

RUN apk add --no-cache --virtual .build-deps \
     curl binutils jq \
    && export VERSION=$(curl -s "https://api.github.com/repos/klzgrad/naiveproxy/releases/latest" | jq -r .tag_name)  \
    && curl --fail --silent -L https://github.com/klzgrad/naiveproxy/releases/download/${VERSION}/naiveproxy-${VERSION}-openwrt-x86_64.tar.xz|  \
      tar xJvf - -C / && mv naiveproxy-* naiveproxy  \
    && strip /naiveproxy/naive  \
    && mv /naiveproxy/naive /usr/local/bin/naive \
    && apk del .build-deps
 
RUN [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf

COPY /entrypoint.sh /

RUN apk add --no-cache \
 ca-certificates  \
 bash  \
 iptables  \
 libstdc++ \
 rm -rf /var/cache/apk/* && \
 chmod a+x /entrypoint.sh
    
ENTRYPOINT [ "/entrypoint.sh" ] 
CMD ["naive", "config.json" ]
