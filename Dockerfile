FROM golang:1.11-alpine as builder

ARG VERSION=5bb8de9

RUN apk add --update git gcc g++ linux-headers
RUN mkdir -p $GOPATH/src/github.com/ethereum && \
    cd $GOPATH/src/github.com/ethereum && \
    git clone https://github.com/ethersphere/go-ethereum && \
    cd $GOPATH/src/github.com/ethereum/go-ethereum && \
    git checkout ${VERSION} && \
    go get github.com/ethereum/go-ethereum && \
    go get . && go get ./cmd/geth && go get ./cmd/swarm && \
    cd $GOPATH/src/github.com/ethereum/go-ethereum && \
    go install -ldflags "-X main.gitCommit=${VERSION}" ./cmd/swarm && \
    go install -ldflags "-X main.gitCommit=${VERSION}" ./cmd/geth && \
    cp $GOPATH/bin/swarm /swarm && cp $GOPATH/bin/geth /geth


# Release image with the required binaries and scripts
FROM alpine:3.8
WORKDIR /
COPY --from=builder /swarm /geth /
ADD run.sh /run.sh
ENTRYPOINT ["/run.sh"]
