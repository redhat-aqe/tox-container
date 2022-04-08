FROM registry.fedoraproject.org/fedora:latest

LABEL maintainer="PnT DevOps Automation - Red Hat, Inc." \
      vendor="PnT DevOps Automation - Red Hat, Inc." \
      summary="Image used to run tests by GitLab pipelines." \
      distribution-scope="public"

# hack to permit tagging the docker image with the git hash
# stolen from:
# https://blog.scottlowe.org/2017/11/08/how-tag-docker-images-git-commit-information/
ARG GIT_COMMIT=unspecified
LABEL git_commit=$GIT_COMMIT

COPY certs/ /etc/pki/ca-trust/source/anchors/
RUN /usr/bin/update-ca-trust

RUN dnf update -y && dnf install -y --setopt=tsflags=nodocs \
      git \
      gcc \
      libxcrypt-compat \
      python3 \
      python3-pip \
      python3-devel \
      python3-tox \
      openldap-devel \
      openssl-devel \
      krb5-devel \
      popt-devel \
      libpq-devel \
      libffi-devel \
      graphviz-devel \
      libxml2-devel \
      libxslt-devel \
      hunspell \
      hunspell-en-US \
      enchant \
      libarchive-devel \
      && dnf clean all

RUN pip3 install awxkit
