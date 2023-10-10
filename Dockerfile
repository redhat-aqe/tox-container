FROM registry.fedoraproject.org/fedora:31

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
      python2 \
      python3 \
      python2-pip \
      python3-pip \
      python2-devel \
      python3-devel \
      python3-tox \
      openldap-devel \
      openssl-devel \
      krb5-devel \
      popt-devel \
      rpm-devel \
      libpq-devel \
      libffi-devel \
      graphviz-devel \
      hunspell \
      hunspell-en-US \
      enchant \
      python2-rpm \
      ShellCheck \
      && dnf clean all

RUN pip3 install awxkit
