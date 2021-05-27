# Https://github.com/xh116 modified
# thanks to https://github.com/klzgrad/naiveproxy

FROM debian:buster AS builder

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /build


RUN apt update \
 && apt install -y git ninja-build python pkg-config llvm libgcc-7-dev ccache curl unzip \
 && git clone --depth 1 https://github.com/klzgrad/naiveproxy.git \
 && cd naiveproxy/src \
 && ./get-clang.sh \
 && ./build.sh
 
 
FROM debian

COPY --from=builder /build/naiveproxy/src/out/Release/naive /usr/local/bin/naive

ENTRYPOINT [ "naive" ]
CMD [ "config.json" ]
