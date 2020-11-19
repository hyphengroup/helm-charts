ARG ATLANTIS_VERSION
FROM runatlantis/atlantis:${ATLANTIS_VERSION}
ARG TERRAGRUNT_VERSION

# Download Terragrunt
RUN curl -s -Lo terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
    chmod +x terragrunt && \
    mv terragrunt /usr/local/bin
