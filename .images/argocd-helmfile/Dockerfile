FROM argoproj/argocd:v1.3.6

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
    curl -o /usr/local/bin/sops -L https://github.com/mozilla/sops/releases/download/v3.5.0/sops-v3.5.0.linux && \
    curl -o /usr/local/bin/helmfile -L https://github.com/roboll/helmfile/releases/download/v0.98.1/helmfile_linux_amd64 && \
    chmod +x /usr/local/bin/helmfile && \
    chmod +x /usr/local/bin/sops

# Switch back to non-root user
USER argocd

ENV HELM_HOME=/home/argocd/.helm

RUN mkdir -p /home/argocd/.helm/plugins && \
    helm plugin install https://github.com/futuresimple/helm-secrets
