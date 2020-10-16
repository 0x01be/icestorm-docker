FROM alpine as build

RUN apk --no-cache add --virtual icestorm-build-dependencies \
    git \
    python3 \
    build-base \
    pkgconfig \
    libftdi1-dev

ENV ICESTORM_REVISION master
RUN git clone --depth 1 --branch ${ICESTORM_REVISION} https://github.com/YosysHQ/icestorm.git /icestorm

WORKDIR /icestorm

RUN make
RUN PREFIX=/opt/icestorm make install

FROM alpine

COPY --from=build /opt/icestorm/ /opt/icestorm/

RUN apk add --no-cache --virtual icestorm-runtime-dependencies \
    libstdc++ \
    libftdi1

RUN adduser -D -u 1000 icestorm

WORKDIR /workspace

RUN chrown icestorm:icestorm /workspace

USER icestorm

ENV PATH $PATH:/opt/icestorm/bin

