ARG ATLANTIS_VERSION
#FROM runatlantis/atlantis:${ATLANTIS_VERSION}
FROM madvalo/atlantis:${ATLANTIS_VERSION}
ARG TERRAGRUNT_VERSION
ARG TERRAFORM_VERSION

# Download Terragrunt
RUN curl -s -Lo terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
    chmod +x terragrunt && \
    mv terragrunt /usr/local/bin

# Make TERRAFORM_VERSION the default
RUN curl -s -Lo terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mkdir -p /usr/local/bin/tf/versions/${TERRAFORM_VERSION} && \
    unlink /usr/local/bin/terraform && \
    unzip terraform.zip -d /usr/local/bin/tf/versions/${TERRAFORM_VERSION} && \
    ln -s /usr/local/bin/tf/versions/${TERRAFORM_VERSION}/terraform /usr/local/bin/terraform && \
    ln -s /usr/local/bin/tf/versions/${TERRAFORM_VERSION}/terraform /usr/local/bin/terraform${TERRAFORM_VERSION}
