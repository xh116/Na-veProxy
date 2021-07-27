FROM ubuntu:latest AS builder


RUN apt-get update && apt-get -y installgit python ninja-build pkg-config curl unzip ccache \
    && git clone --depth 1 https://github.com/klzgrad/naiveproxy.git \
    && cd naiveproxy/src \
    && ./get-clang.sh \
    && ./build.sh \
    && tar -xJvf $(find ./out/Release/ -name "*naiveproxy*openwrt-x86_64*") \
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
