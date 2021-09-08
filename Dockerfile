FROM --platform=${BUILDPLATFORM} alpine:latest AS builder
ARG TARGETPLATFORM
RUN case ${TARGETPLATFORM} in \
         "linux/amd64")  ARCH=amd64-openwrt-x86_64  ;; \
         "linux/arm64")  ARCH=linux-arm64  ;; \
         "linux/arm/v7") ARCH=linux-arm  ;; \
    esac \

 && export VERSION=$(curl -s "https://api.github.com/repos/klzgrad/naiveproxy/releases/latest" | jq -r .tag_name)  \   
 && curl --fail --silent -L https://github.com/klzgrad/naiveproxy/releases/download/${VERSION}/naiveproxy-${VERSION}-${ARCH}.tar.xz | \
    tar xJvf - -C / && mv naiveproxy-* naiveproxy  \
 && strip /naiveproxy/naive  \
 && mv /naiveproxy/naive /usr/local/bin/naive \
 && apk del .build-deps
 

FROM alpine:latest

COPY --from=builder /naiveproxy/naive /usr/local/bin/naive
 
RUN [ ! -e /etc/nsswitch.conf ] && echo 'hosts: files dns' > /etc/nsswitch.conf

COPY /entrypoint.sh /

RUN apk --no-cache add iptables ca-certificates bash libstdc++ tzdata &&\
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime &&\
    apk del tzdata &&\
    rm -rf /var/cache/apk/* &&\
    chmod a+x /entrypoint.sh
    
#ENTRYPOINT [ "/entrypoint.sh" ] 
CMD ["naive", "config.json" ]
