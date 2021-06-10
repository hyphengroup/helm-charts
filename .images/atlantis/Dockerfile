ARG ATLANTIS_VERSION
FROM runatlantis/atlantis:v${ATLANTIS_VERSION}
ARG DEFAULT_TERRAGRUNT_VERSION

# Download Terragrunt
# Latest patch versions are included
RUN TERRAGRUNT_VERSIONS="0.21.13 0.22.5 0.23.40 0.24.4 0.25.5 0.26.7 0.27.4 0.28.7 ${DEFAULT_TERRAGRUNT_VERSION}" && \
    for VERSION in ${TERRAGRUNT_VERSIONS}; do \
        curl -LOs https://github.com/gruntwork-io/terragrunt/releases/download/v${VERSION}/terragrunt_linux_amd64 && \
        curl -LOs https://github.com/gruntwork-io/terragrunt/releases/download/v${VERSION}/SHA256SUMS && \
        sed -n "/terragrunt_linux_amd64/p" SHA256SUMS | sha256sum -c && \
        chmod +x terragrunt_linux_amd64 && \
        mkdir -p /usr/local/bin/tg/versions/${VERSION} && \
        mv terragrunt_linux_amd64 /usr/local/bin/tg/versions/${VERSION}/terragrunt && \
        ln -fsv /usr/local/bin/tg/versions/${VERSION}/terragrunt /usr/local/bin/terragrunt${VERSION} && \
        rm SHA256SUMS; \
    done && \
    ln -sv /usr/local/bin/tg/versions/${DEFAULT_TERRAGRUNT_VERSION}/terragrunt /usr/local/bin/terragrunt

