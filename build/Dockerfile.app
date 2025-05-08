FROM docker.io/alpine:latest AS ca_cert_source

RUN apk update && apk upgrade && apk add --no-cache ca-certificates
RUN update-ca-certificates

# Copy release asssets to scratch image
FROM scratch

COPY --from=ca_cert_source /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ARG TARGETARCH TARGETOS
ADD dist/app_${TARGETOS}_${TARGETARCH}*/app /app
ADD ui/app/dist/spa /static
ADD ui/swagger.json /static/swagger.json
ADD ui/app/src/statics /static/statics

ENTRYPOINT ["/app"]
