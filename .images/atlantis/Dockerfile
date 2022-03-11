ARG ATLANTIS_VERSION
FROM runatlantis/atlantis:v${ATLANTIS_VERSION}
ARG DEFAULT_TERRAGRUNT_VERSION

# These should be the default but let's make sure.
ENV TFENV_AUTO_INSTALL=true
ENV TGENV_AUTO_INSTALL=true

RUN \
  default_version="$(terraform version | head -1 | awk '{print $2}' | sed 's/^v//')" && \
  git clone --depth=1 https://github.com/tfutils/tfenv.git /home/atlantis/.tfenv && \
  ln -sfv /home/atlantis/.tfenv/bin/* /usr/local/bin && \
  tfenv install "${default_version}" && \
  echo "${default_version}" >/home/atlantis/.terraform-version && \
  echo "${default_version}" >/home/atlantis/.tfenv/version

RUN \
  git clone --depth=1 https://github.com/taosmountain/tgenv.git /home/atlantis/.tgenv && \
  ln -sfv /home/atlantis/.tgenv/bin/* /usr/local/bin && \
  for v in 0.23.40 0.28.7 0.28.24 0.31.8 "${DEFAULT_TERRAGRUNT_VERSION}"; do \
    tgenv install "${v}" || :; \
  done && \
  echo "${DEFAULT_TERRAGRUNT_VERSION}" >/home/atlantis/.terragrunt-version && \
  echo "${DEFAULT_TERRAGRUNT_VERSION}" >/home/atlantis/.tgenv/version

# Download terragrunt-atlantis-config
ARG TERRAGRUNT_ATLANTIS_CONFIG_VERSION
RUN curl -LOs https://github.com/transcend-io/terragrunt-atlantis-config/releases/download/v${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}/terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64.tar.gz && \
  tar zxf terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64.tar.gz && \
  chmod +x terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64/terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64 && \
  mv terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64/terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64 /usr/local/bin/terragrunt-atlantis-config && \
  rm -rf terragrunt-atlantis-config_${TERRAGRUNT_ATLANTIS_CONFIG_VERSION}_linux_amd64*

# Download Terraform provider for teleport
ARG TELEPORT_VERSION
RUN TELEPORT_PLATFORMS="linux darwin" && \
  apk add --no-cache libc6-compat && \
  for PLATFORM in ${TELEPORT_PLATFORMS}; do \
    mkdir -p /home/atlantis/.terraform.d/plugins/gravitational.com/teleport/teleport/${TELEPORT_VERSION}/${PLATFORM}_amd64 && \
    curl -LOs https://get.gravitational.com/terraform-provider-teleport-v${TELEPORT_VERSION}-${PLATFORM}-amd64-bin.tar.gz && \
    tar -zxvf terraform-provider-teleport-v${TELEPORT_VERSION}-${PLATFORM}-amd64-bin.tar.gz -C /home/atlantis/.terraform.d/plugins/gravitational.com/teleport/teleport/${TELEPORT_VERSION}/${PLATFORM}_amd64 && \
    rm terraform-provider-teleport-v${TELEPORT_VERSION}-${PLATFORM}-amd64-bin.tar.gz; \
  done

RUN chown -R atlantis:atlantis /home/atlantis
