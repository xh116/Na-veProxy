# Https://github.com/xh116 modified
# thanks to https://github.com/klzgrad/naiveproxy


FROM debian:latest

ENV NAIVEPROXY_VERSION=v90.0.4430.85-10

RUN apt-get update \
  && apt-get install -y wget tar\
  && mkdir -p /naiveproxy \ 
  && cd /naiveproxy \ 
  && wget https://github.com/klzgrad/naiveproxy/releases/download/${NAIVEPROXY_VERSION}/naiveproxy-${NAIVEPROXY_VERSION}-linux-x64.tar.xz \
  && tar -xf naiveproxy-v90.0.4430.85-10-linux-x64.tar.xz
  
COPY /naiveproxy/naive /usr/local/bin/naive

ENTRYPOINT [ "naive" ]
CMD [ "config.json" ]
