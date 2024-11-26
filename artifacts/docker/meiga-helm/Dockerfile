FROM ubuntu:latest as base

RUN apt update && apt install -y git

WORKDIR library

RUN git clone https://github.com/prefapp/docker-meiga.git

FROM php:7.2.34-alpine3.12 as final

WORKDIR library

COPY --from=base /library/docker-meiga . 

CMD ["php", "-S", "0.0.0.0:80"]
