FROM registry.fedoraproject.org/fedora:38

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

RUN dnf update -y
RUN dnf install -y --setopt=tsflags=nodocs \
      git \
      gcc \
      libxcrypt-compat \
      python3-devel \
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
      libacl-devel \
      patch \
      zlib-devel \
      bzip2 \
      bzip2-devel \
      readline-devel \
      sqlite \
      sqlite-devel \
      xz \
      xz-devel \
      && dnf clean all

# switch to python3.6
RUN git clone https://github.com/pyenv/pyenv.git /pyenv
ENV PYENV_ROOT /pyenv
RUN /pyenv/bin/pyenv install 3.6.15
RUN echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
RUN echo 'eval "$(/pyenv/bin/pyenv init -)"' >> ~/.bashrc && /pyenv/bin/pyenv global 3.6.15
RUN /pyenv/versions/3.6.15/bin/pip install awxkit tox
