# Update versions in Makefile!
ARG ARGO_VERSION

FROM argoproj/argocd:v${ARGO_VERSION}
ARG SOPS_VERSION
ARG HELMFILE_VERSION

# Switch to root for the ability to perform install
USER root

# Install tools needed for your repo-server to retrieve & decrypt secrets, render manifests
# (e.g. curl, awscli, gpg, sops)
# Newer version of argo (1.5.x onwards) replaces helm 2 with helm 3. While both binaries exist, 'helm'
# points to helm3. This breaks many of our tools since we call helm directly
# In order to maintain compatibility, we create our own softlink below
RUN apt-get update && \
    apt-get install -y \
        curl \
        awscli \
        gnupg \
        sudo \
        nano && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    echo "https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux"  && \
    curl -o /usr/local/bin/sops -L https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux && \
    echo "https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64" && \
    curl -o /usr/local/bin/helmfile -L https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_amd64 && \
    chmod +x /usr/local/bin/helmfile && \
    chmod +x /usr/local/bin/sops && \
    mv /usr/local/bin/helm /usr/local/bin/helm3 && \
    ln --symbolic --verbose /usr/local/bin/helm2 /usr/local/bin/helm

# Switch back to non-root user
USER argocd

ENV HELM_HOME=/home/argocd/.helm

RUN mkdir -p /home/argocd/.helm/plugins && \
    helm plugin install https://github.com/futuresimple/helm-secrets
