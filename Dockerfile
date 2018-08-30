FROM alpine:latest as certs
RUN apk --update add ca-certificates

FROM golang:1.9.1 as app
WORKDIR /go/src/github.ibm.com/alchemy-containers/armada-app/
COPY . /go/src/github.ibm.com/alchemy-containers/armada-app/
RUN make buildgo

FROM scratch
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY etc/* /go/src/github.ibm.com/alchemy-containers/armada-app/etc/
COPY --from=app /go/src/github.ibm.com/alchemy-containers/sample-app/armada-app /go/bin/

ENV GOPATH /go

# Run the api command and log to standard error by default.
ENTRYPOINT ["/go/bin/armada-app"]

# Service listens on port 6969.
EXPOSE 6969
