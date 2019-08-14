FROM golang:1.12-alpine
ARG VERSION=1.3.4
RUN apk add --upgrade --no-cache git curl gcc libc-dev && \
    go get github.com/cloudflare/cfssl_trust/... && \
	go get github.com/GeertJohan/go.rice/rice && \
    mkdir -p /go/src/github.com/cloudflare/cfssl
WORKDIR /go/src/github.com/cloudflare/cfssl/
RUN curl -sSL https://github.com/cloudflare/cfssl/archive/${VERSION}.tar.gz | tar xz --strip 1 && \
    rice embed-go -i=./cli/serve && \
	mkdir -p bin && cd bin && \
	go build ../cmd/cfssl && \
	go build ../cmd/cfssljson && \
	go build ../cmd/mkbundle && \
	go build ../cmd/multirootca
WORKDIR /go/src/github.com/cloudflare/cfssl_trust
RUN tar -czf bundle.tar.gz README.md int-bundle.crt ca-bundle.* certdata/trusted_roots/
	
	
FROM alpine:3.10
LABEL maintainer "Levent SAGIROGLU <LSagiroglu@gmail.com>"
EXPOSE 8888
COPY --from=0 /go/src/github.com/cloudflare/cfssl_trust/bundle.tar.gz /tmp
COPY --from=0 /go/src/github.com/cloudflare/cfssl/bin/ /usr/bin
RUN apk add --upgrade --no-cache openssl && \
    mkdir /etc/cfssl && \
    tar -xzf /tmp/bundle.tar.gz -C /etc/cfssl && \
    rm /tmp/bundle.tar.gz
VOLUME ["/shared" ]
WORKDIR /shared