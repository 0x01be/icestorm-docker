FROM 0x01be/alpine:edge as builder

RUN apk --no-cache add --virtual icestorm-build-dependencies \
    git \
    python3 \
    build-base \
    pkgconfig \
    libftdi1-dev

RUN git clone https://github.com/cliffordwolf/icestorm.git /icestorm

WORKDIR /icestorm

RUN make
RUN PREFIX=/opt/icestorm make install

FROM 0x01be/alpine:edge

COPY --from=builder /opt/icestorm/ /opt/icestorm/

ENV PATH $PATH:/opt/ocestorm/bin

