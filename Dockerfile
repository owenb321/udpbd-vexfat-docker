FROM rust:1-alpine3.19 as build

RUN apk add --no-cache git build-base

WORKDIR /src

RUN git clone --recurse-submodules https://github.com/awaken1ng/udpbd-vexfat.git

WORKDIR /src/udpbd-vexfat

RUN cargo build -r --target-dir .


FROM alpine:3.19

VOLUME ["/games"]
EXPOSE 48573/udp

RUN apk add --no-cache tini

COPY --from=build /src/udpbd-vexfat/release/udpbd-vexfat /usr/local/bin/udpbd-vexfat

CMD ["tini", "udpbd-vexfat", "/games"]
