ARG ALPINE_LINUX_VERSION="3.11"

FROM golang:1-alpine${ALPINE_LINUX_VERSION}

EXPOSE 8080
ENV LISTEN_ADDR 0.0.0.0:8080

#http://dl-cdn.alpinelinux.org/alpine/MIRRORS.txt
RUN set -xe \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
    && apk --no-cache add ca-certificates tzdata

WORKDIR /go/src/app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN go generate -mod=vendor

CMD ["go", "run", "-mod=vendor", "main.go", "-debug"]
