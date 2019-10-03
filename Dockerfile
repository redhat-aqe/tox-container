FROM fedora:latest

LABEL maintainer="PnT DevOps Automation - Red Hat, Inc." \
      vendor="PnT DevOps Automation - Red Hat, Inc." \
      summary="Image used to run tests by GitLab pipelines." \
      distribution-scope="public"

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
                libpq-devel \
                graphviz-devel && \
    dnf clean all
