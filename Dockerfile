FROM 0x01be/base as build

WORKDIR /icestorm

ENV REVISION=master
RUN apk --no-cache add --virtual icestorm-build-dependencies \
    git \
    python3 \
    build-base \
    pkgconfig \
    libftdi1-dev &&\
    git clone --depth 1 --branch ${ICESTORM_REVISION} https://github.com/YosysHQ/icestorm.git /icestorm &&\
    make
RUN PREFIX=/opt/icestorm make install

FROM 0x01be/base

COPY --from=build /opt/icestorm/ /opt/icestorm/

WORKDIR /workspace
RUN apk add --no-cache --virtual icestorm-runtime-dependencies \
    libstdc++ \
    libftdi1 &&\
    adduser -D -u 1000 icestorm &&\
    mkdir -p /workspace &&\
    hown icestorm:icestorm /workspace

USER icestorm
ENV PATH=${PATH}:/opt/icestorm/bin

