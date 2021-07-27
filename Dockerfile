FROM ubuntu:21.04 AS builder

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -qq install git python ninja-build pkg-config curl unzip ccache libstdc++-10-dev \
    && git clone --depth 1 https://github.com/klzgrad/naiveproxy.git \
    && cd naiveproxy/src \
    && export TARGET="$(EXTRA_FLAGS='target_cpu="x64" target_os="openwrt" use_allocator="none" use_allocator_shim=false' OPENWRT_FLAGS='arch=x86_64 release=19.07.7 gcc_ver=7.5.0 target=x86 subtarget=64')" \
    && $TARGET ./get-clang.sh \
    && $TARGET ./build.sh 
    #&& tar -xJvf $(find ./out/Release/ -name "*naiveproxy*openwrt-x86_64*") \
    
FROM alpine:latest 

#COPY /entrypoint.sh /
COPY --from=builder /naiveproxy/src/out/Release/naive /usr/local/bin/

RUN apk add --no-cache \
 ca-certificates  \
 bash  \
 iptables  \
 libstdc++ \
 rm -rf /var/cache/apk/*  
 #chmod a+x /entrypoint.sh
    
#ENTRYPOINT [ "/entrypoint.sh" ] 
CMD ["naive", "config.json" ]
