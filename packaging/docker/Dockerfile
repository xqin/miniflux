ARG GOLANG_VERSION="1.17.8"
ARG ALPINE_LINUX_VERSION="3.15"

FROM golang:${GOLANG_VERSION}-alpine${ALPINE_LINUX_VERSION} as build


#http://dl-cdn.alpinelinux.org/alpine/MIRRORS.txt
RUN set -xe \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk add --no-cache --update git

WORKDIR /go/src/app

ENV GO111MODULE=on \
    GOPROXY=https://goproxy.cn,https://goproxy.io,direct

COPY go.mod go.sum ./

RUN go mod download

COPY . .

RUN set -xe \
    && go generate \
    && go build \
      -o miniflux \
      -ldflags="-s -w -X 'miniflux.app/version.Version=`git describe --tags --abbrev=0`' -X 'miniflux.app/version.Commit=`git rev-parse --short HEAD`' -X 'miniflux.app/version.BuildDate=`date +%FT%T%z`'" \
      main.go


FROM alpine:${ALPINE_LINUX_VERSION}
EXPOSE 8080
ENV LISTEN_ADDR 0.0.0.0:8080

RUN set -xe \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk --no-cache add ca-certificates tzdata

COPY --from=build /go/src/app/miniflux /usr/bin/miniflux
USER nobody
CMD ["/usr/bin/miniflux"]
