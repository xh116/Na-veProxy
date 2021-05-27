# Https://github.com/xh116 modified
# thanks to https://github.com/klzgrad/naiveproxy


FROM debian:latest

ENV NAIVEPROXY_VERSION=v90.0.4430.85-10

RUN apt install curl \
  && curl https://github.com/klzgrad/naiveproxy/releases/download/${NAIVEPROXY_VERSION}/naiveproxy-${NAIVEPROXY_VERSION}-linux-x64.tar.xz | \
     tar xJvf - -C / && mv naiveproxy-* naiveproxy \
  
  

ENTRYPOINT [ "/naiveproxy/naive" ]
CMD [ "/naiveproxy/config.json" ]
