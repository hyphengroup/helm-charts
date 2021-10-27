ARG ATLANTIS_VERSION
FROM runatlantis/atlantis:v${ATLANTIS_VERSION}
ARG DEFAULT_TERRAGRUNT_VERSION

# Download Terragrunt
# Latest patch versions are included
RUN TERRAGRUNT_VERSIONS="0.23.40 0.28.7 0.28.24 0.31.8 ${DEFAULT_TERRAGRUNT_VERSION}" && \
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

# Download terragrunt-atlantis-config
ARG TERRAGRUNT_ATLANTIS_CONFIG_VERSION
RUN curl -LOs https://github.com/transcend-io/terragrunt-atlantis-config/releases/download/v${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}/terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64.tar.gz && \
  tar zxf terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64.tar.gz && \
  chmod +x terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64/terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64 && \
  mv terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64/terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64 /usr/local/bin/terragrunt-atlantis-config && \
  rm -rf terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64*

# Download Terraform provider for teleport
ARG TELEPORT_VERSION
RUN mkdir -p /home/atlantis/.terraform.d/plugins/gravitational.com/teleport/teleport/${TELEPORT_VERSION}/linux_amd64 && \
  curl -L -O https://get.gravitational.com/terraform-provider-teleport-v${TELEPORT_VERSION}-linux-amd64-bin.tar.gz && \
  tar -zxvf terraform-provider-teleport-v${TELEPORT_VERSION}-linux-amd64-bin.tar.gz -C /home/atlantis/.terraform.d/plugins/gravitational.com/teleport/teleport/${TELEPORT_VERSION}/linux_amd64 && \
  rm terraform-provider-teleport-v${TELEPORT_VERSION}-linux-amd64-bin.tar.gz
