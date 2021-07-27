FROM ubuntu:latest AS builder


RUN apt-get update && apt-get install git python ninja-build  pkg-config curl unzip ccache \
    && git clone --depth 1 https://github.com/klzgrad/naiveproxy.git \
    && cd naiveproxy/src \
    && ./get-clang.sh \
    && ./build.sh \
    && tar -xf ./out/Release/naive/naiveproxy-v92.0.4515.107-1-openwrt-x86_64.tar.xz \
    && mv naiveproxy-* naiveproxy  


FROM alpine:latest 

COPY /entrypoint.sh /
COPY --from=builder /naiveproxy/src/naiveproxy/naive /usr/local/bin/

RUN apk add --no-cache \
 ca-certificates  \
 bash  \
 iptables  \
 libstdc++ \
 rm -rf /var/cache/apk/* && \
 chmod a+x /entrypoint.sh
    
ENTRYPOINT [ "/entrypoint.sh" ] 
CMD ["naive", "config.json" ]
