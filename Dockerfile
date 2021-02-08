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

RUN adduser -u 1000 -H -D app \
    && chown 1000:1000 /app \
    && mkdir -p /etc/crontabs/ \
    && echo "*/15   *   *   *   *   /app" > /etc/crontabs/app \
    && chown 1000:1000 /etc/crontabs/app

USER app
ENTRYPOINT [ "crond", "-f" ]
