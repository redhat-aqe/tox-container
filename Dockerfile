FROM registry.fedoraproject.org/fedora:40

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
      ShellCheck \
      hadolint \
      && dnf clean all

# Install rover for GraphQL federated schema manipulation
ENV ROVER_VERSION=v0.23.0
RUN mkdir -p /opt/rover-$ROVER_VERSION \
    && curl -sSL -o /tmp/rover-$ROVER_VERSION.tar.gz https://github.com/apollographql/rover/releases/download/$ROVER_VERSION/rover-$ROVER_VERSION-x86_64-unknown-linux-gnu.tar.gz \
    && tar -xvzf /tmp/rover-$ROVER_VERSION.tar.gz -C /opt/rover-$ROVER_VERSION \
    && rm /tmp/rover-$ROVER_VERSION.tar.gz \
    && ln -fs /opt/rover-$ROVER_VERSION/dist/rover /usr/local/bin/rover

# switch to Python 3.12
RUN git clone https://github.com/pyenv/pyenv.git /pyenv
ENV PYENV_ROOT /pyenv
RUN /pyenv/bin/pyenv install 3.12.4
RUN echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
RUN echo 'eval "$(/pyenv/bin/pyenv init -)"' >> ~/.bashrc && /pyenv/bin/pyenv global 3.12.4
RUN /pyenv/versions/3.12.4/bin/pip install awxkit tox

ENTRYPOINT ["/bin/bash", "-l" ,"-c"]
