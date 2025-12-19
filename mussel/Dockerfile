FROM alpine:3.19.1
ARG platform=x86-64
RUN apk add --no-cache \
  bash \
  binutils \
  bison \
  bzip2 \
  coreutils \
  g++ \
  gawk \
  gcc \
  git \
  grep \
  gzip \
  make \
  musl-utils \
  patch \
  perl \
  rsync \
  sed \
  tar \
  texinfo \
  wget \
  xz \
  zstd-dev

WORKDIR /build
ADD --checksum=sha256:3ff8721a6546b0ba9abc21c72fb953a8e0b36e97ba7a72d1f3a10b9fcf0a5688 https://github.com/firasuke/mussel/archive/cc73b4b25b4bdeb881dbcee4e1ebe3b8351adb26.tar.gz mussel.tar.gz
RUN tar --strip-components=1 --extract --file mussel.tar.gz

RUN ./check
RUN ./mussel $platform

ENTRYPOINT ["bash"]
