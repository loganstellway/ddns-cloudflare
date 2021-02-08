#########
# BUILD #
#########
ARG GO_VERSION="1.15.7"
ARG ALPINE_VERSION="3.13.1"
FROM golang:${GO_VERSION}-alpine as build

WORKDIR /go
COPY ./src /go/appsrc
RUN apk add --no-cache git \
    && go get github.com/cloudflare/cloudflare-go \
    && go build -o app ./appsrc/*

#######
# RUN #
#######
FROM alpine:${ALPINE_VERSION}

COPY --from=build /go/app /app

RUN mkdir -p /etc/crontabs/ \
    && echo "*/15   *   *   *   *   /app" > /etc/crontabs/root

ENTRYPOINT [ "crond", "-f" ]
