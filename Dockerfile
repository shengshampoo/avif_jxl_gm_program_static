FROM alpine:latest

# https://mirrors.alpinelinux.org/
RUN sed -i 's@dl-cdn.alpinelinux.org@ftp.halifax.rwth-aachen.de@g' /etc/apk/repositories

RUN apk update
RUN apk upgrade

# required avif  
RUN apk add --no-cache \
 gcc make linux-headers musl-dev \
 zlib-dev zlib-static python3-dev \
 curl git libpng-dev libpng-static \
 libwebp-dev libwebp-static libjpeg-turbo-dev libjpeg-turbo-static \
 cmake ninja meson g++ nasm perl \
 openssl-dev openssl-libs-static \
 xz-static xz-dev libtool \
 autoconf automake patch bash \
 rust cargo cargo-c

COPY build-static-avif.sh build-static-avif.sh
RUN chmod +x ./build-static-avif.sh
RUN bash ./build-static-avif.sh 
