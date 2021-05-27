# Https://github.com/xh116 modified
# thanks to https://github.com/klzgrad/naiveproxy


FROM debian:latest

ENV NAIVEPROXY_VERSION=v90.0.4430.85-10


RUN apt-get update && apt-get install -y curl xz-utils && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /naiveproxy \ 
    && curl --fail --silent -L https://github.com/klzgrad/naiveproxy/releases/download/${NAIVEPROXY_VERSION}/naiveproxy-${NAIVEPROXY_VERSION}-linux-x64.tar.xz | \
      tar xJvf - -C / && mv naiveproxy-* naiveproxy \
    && strip /naiveproxy/naive \
    && mv /naiveproxy/naive /usr/local/bin/naive
    
ENV LANG en_US.utf8


ENTRYPOINT [ "naive" ]
CMD [ "config.json" ]
