FROM alpine as builder

RUN apk --no-cache add --virtual icestorm-build-dependencies \
    git \
    python3 \
    build-base \
    pkgconfig \
    libftdi1-dev

RUN git clone --depth 1 https://github.com/YosysHQ/icestorm.git /icestorm

WORKDIR /icestorm

RUN make
RUN PREFIX=/opt/icestorm make install

FROM alpine

COPY --from=builder /opt/icestorm/ /opt/icestorm/

ENV PATH $PATH:/opt/icestorm/bin

