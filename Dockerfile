FROM ubuntu:latest AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -qq install git python ninja-build pkg-config curl unzip ccache libstdc++-10-dev \
    && git clone --depth 1 https://github.com/klzgrad/naiveproxy.git \
    && cd naiveproxy/src \
    && EXTRA_FLAGS='target_cpu="${{ matrix.arch }}"' ./get-clang.sh \
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
