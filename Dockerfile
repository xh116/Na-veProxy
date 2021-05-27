# Https://github.com/xh116 modified
# thanks to https://github.com/klzgrad/naiveproxy


FROM debian:latest

ENV NAIVEPROXY_VERSION=v90.0.4430.85-10


RUN apt-get update && apt-get install -y locales curl xz-util && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
    && mkdir -p /naiveproxy \ 
    && curl -L https://github.com/klzgrad/naiveproxy/releases/download/${NAIVEPROXY_VERSION}/naiveproxy-${NAIVEPROXY_VERSION}-linux-x64.tar.xz \
    && tar xJvf naiveproxy-${NAIVEPROXY_VERSION}-linux-x64.tar.xz \
    && mv /naiveproxy-${NAIVEPROXY_VERSION}-linux-x64/naive /usr/local/bin/naive
    
ENV LANG en_US.utf8


ENTRYPOINT [ "naive" ]
CMD [ "config.json" ]
