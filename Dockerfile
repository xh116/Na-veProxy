# Https://github.com/xh116 modified
# thanks to https://github.com/klzgrad/naiveproxy

FROM ubuntu:latest AS builder

WORKDIR /build

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


RUN apt update \
 && apt install -y git ninja-build python pkg-config libnss3-dev llvm-7.0-dev ccache \
    curl unzip \
 && git clone --depth 1 https://github.com/klzgrad/naiveproxy.git \
 && cd naiveproxy/src \
 && ./get-clang.sh \
 && ./build.sh
 
 
FROM ubuntu

COPY --from=builder /build/naiveproxy/src/out/Release/naive /usr/local/bin/naive

RUN apt update \
 && apt install -y libnss3 \
 && rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "naive" ]
CMD [ "config.json" ]
