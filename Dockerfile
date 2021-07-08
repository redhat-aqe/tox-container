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

# Rrovide way to add user in entrypoint for openshift runs
RUN chmod -R g=u /etc/passwd

RUN dnf install -y --setopt=tsflags=nodocs \
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
      hunspell \
      hunspell-en-US \
      enchant \
      && dnf clean all

RUN pip3 install awxkit

# Trust this certificate used for internal Red Hat services.
COPY RH-IT-Root-CA.crt /etc/pki/ca-trust/source/anchors/RH-IT-Root-CA.crt
RUN update-ca-trust

# Respect system bundle even if requests is installed by pip.
ENV REQUESTS_CA_BUNDLE /etc/pki/tls/certs/ca-bundle.crt
