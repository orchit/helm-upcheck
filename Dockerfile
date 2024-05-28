FROM nginx:stable-alpine-perl
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
WORKDIR /usr/src/app

RUN mkdir -p /usr/src/app/web

COPY files/nginx.conf /etc/nginx/nginx.conf

RUN apk add --no-cache \
    wget \
    curl \
    bash \
    nano jq \
    tar fcgiwrap

# kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"  && \
    mv ./kubectl /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl && \
    kubectl version --client

# Helm
ARG HELM_VERSION=3.14.0
ENV HELM_URL=https://get.helm.sh/helm-v"${HELM_VERSION}"-linux-amd64.tar.gz
RUN curl -LSs $HELM_URL | tar xz && \
    mv linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    helm version

# Nova
ARG NOVA_VERSION=3.9.0
ENV NOVA_URL=https://github.com/FairwindsOps/nova/releases/download/${NOVA_VERSION}/nova_${NOVA_VERSION}_linux_amd64.tar.gz
RUN curl -LSs $NOVA_URL | tar xz && \
    mv ./nova /usr/local/bin/nova && \
    chmod +x /usr/local/bin/nova && \
    nova version

COPY files/saveEnv.sh /usr/local/bin/
COPY files/transform.sh /usr/local/bin/
COPY files/update.sh /usr/local/bin/
COPY files/update.pm /usr/lib/perl5/vendor_perl/x86_64-linux-thread-multi/
#COPY opt/ /opt/kube-powertools/
RUN chmod +x /usr/local/bin/*.sh
RUN ln -s /usr/local/bin/update.sh /docker-entrypoint.d/02-update.sh
RUN ln -s /usr/local/bin/saveEnv.sh /docker-entrypoint.d/01-saveEnv.sh
