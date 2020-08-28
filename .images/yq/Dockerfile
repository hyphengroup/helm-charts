FROM alpine:3.12
ARG YQ_BIN_VERSION=3.3.2

RUN wget -O /usr/local/bin/yq "https://github.com/mikefarah/yq/releases/download/${YQ_BIN_VERSION}/yq_linux_amd64" \ 
    && chmod +x /usr/local/bin/yq \
    && apk add --no-cache jq

ENTRYPOINT ["/usr/local/bin/yq"]
