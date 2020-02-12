# Update versions in Makefile!
ARG ARGO_VERSION
ARG SOPS_VERSION
ARG HELMFILE_VERSION

FROM argoproj/argocd:v${ARGO_VERSION}

# Switch to root for the ability to perform install
USER root

# Install tools needed for your repo-server to retrieve & decrypt secrets, render manifests
# (e.g. curl, awscli, gpg, sops)
RUN apt-get update && \
    apt-get install -y \
        curl \
        awscli \
        gnupg \
        sudo \
        nano && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    curl -o /usr/local/bin/sops -L https://github.com/mozilla/sops/releases/download/v{SOPS_VERSION}/sops-v{SOPS_VERSION}.linux && \
    curl -o /usr/local/bin/helmfile -L https://github.com/roboll/helmfile/releases/download/v{HELMFILE_VERSION}/helmfile_linux_amd64 && \
    chmod +x /usr/local/bin/helmfile && \
    chmod +x /usr/local/bin/sops

# Switch back to non-root user
USER argocd

ENV HELM_HOME=/home/argocd/.helm

RUN mkdir -p /home/argocd/.helm/plugins && \
    helm plugin install https://github.com/futuresimple/helm-secrets
