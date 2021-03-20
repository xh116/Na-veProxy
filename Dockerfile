FROM ubuntu:latest AS builder

WORKDIR /build
RUN apt-get update \
 && apt-get install -y git ninja-build pkg-config libnss3-dev curl unzip ccache tzdata  \
        curl unzip \
 && git clone --depth 1 https://github.com/klzgrad/naiveproxy.git \
 && cd naiveproxy/src \
 && ./get-clang.sh \
 && ./build.sh

ENV TZ=Asia/Shanghai

FROM ubuntu

COPY --from=builder /build/naiveproxy/src/out/Release/naive /usr/local/bin/naive

RUN apt-get update \
 && apt-get install -y libnss3 \
 && rm -rf /var/lib/apt/lists/*

ENTRYPOINT [ "naive" ]
CMD [ "--listen=socks://0.0.0.0:1080", "--log" ]
