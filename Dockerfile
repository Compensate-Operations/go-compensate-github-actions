FROM golang:alpine

ENV GO111MODULE=on

RUN apk update && \
        apk add -u jq curl && \
	go get -u golang.org/x/lint/golint

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
