ARG GO_VERSION="1.15.6"
FROM golang:${GO_VERSION}-alpine

# Default to run cron every 4 hours
ENV CRON_SCHEDULE="0   */3   *   *   *"
ENV API_PORT=8080
WORKDIR /go/src/app
COPY ./src/ /go/src/app/
RUN apk add --no-cache git \
    && go get github.com/cloudflare/cloudflare-go \
    && go build -o app ./* \
    && (crontab -u $(whoami) -l; echo "$CRON_SCHEDULE   /go/src/app/app") | crontab -u $(whoami) -

ENTRYPOINT [ "crond", "-f" ]
