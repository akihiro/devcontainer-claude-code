FROM docker.io/library/buildpack-deps:trixie AS sg
WORKDIR /work
RUN curl -sSL -o output.zip https://github.com/ast-grep/ast-grep/releases/download/0.42.1/app-x86_64-unknown-linux-gnu.zip
RUN echo 5de8b87cba67fc8dc3e239d54b6484802ad745a7ae3de76be4fe89661dc52657 output.zip | sha256sum -c
RUN unzip output.zip
RUN install -o root -g root -m 0755 ast-grep /usr/local/bin/
RUN install -o root -g root -m 0755 sg /usr/local/bin/

FROM docker.io/library/buildpack-deps:trixie AS fd
WORKDIR /work
RUN curl -sSL -o output.tar.gz https://github.com/sharkdp/fd/releases/download/v10.4.2/fd-v10.4.2-x86_64-unknown-linux-gnu.tar.gz
RUN echo def59805cd14b5651b68990855f426ad087f3b96881296d963910431ba3143c8 output.tar.gz | sha256sum -c
RUN tar xaf output.tar.gz
RUN install -o root -g root -m 0755 ./fd-v10.4.2-x86_64-unknown-linux-gnu/fd /usr/local/bin/

FROM docker.io/library/buildpack-deps:trixie AS gh
WORKDIR /work
RUN curl -sSL -o output.tar.gz https://github.com/cli/cli/releases/download/v2.91.0/gh_2.91.0_linux_amd64.tar.gz
RUN echo 304a0d2460f4a8847d2f192bad4e2a32cd9420d28716e7ae32198181b65b5f9c output.tar.gz | sha256sum -c
RUN tar xaf output.tar.gz
RUN install -o root -g root -m 0755 ./gh_2.91.0_linux_amd64/bin/gh /usr/local/bin/

FROM docker.io/library/buildpack-deps:trixie AS glab
WORKDIR /work
RUN curl -sSL -o output.tar.gz https://gitlab.com/gitlab-org/cli/-/releases/v1.92.1/downloads/glab_1.92.1_linux_amd64.tar.gz
RUN echo b95eba8934bb202d868c92c8b1b0806beccb456edaf096f02e2ac99e98a66b52 output.tar.gz | sha256sum -c
RUN tar xaf output.tar.gz
RUN install -o root -g root -m 0755 ./bin/glab /usr/local/bin/

FROM docker.io/library/buildpack-deps:trixie AS jq
WORKDIR /work
RUN curl -sSL -o jq https://github.com/jqlang/jq/releases/download/jq-1.8.1/jq-linux-amd64
RUN echo 020468de7539ce70ef1bceaf7cde2e8c4f2ca6c3afb84642aabc5c97d9fc2a0d jq | sha256sum -c
RUN install -o root -g root -m 0755 jq /usr/local/bin/

FROM docker.io/library/buildpack-deps:trixie AS rg
WORKDIR /work
RUN curl -sSL -o output.tar.gz https://github.com/BurntSushi/ripgrep/releases/download/15.1.0/ripgrep-15.1.0-x86_64-unknown-linux-musl.tar.gz
RUN echo 1c9297be4a084eea7ecaedf93eb03d058d6faae29bbc57ecdaf5063921491599 output.tar.gz | sha256sum -c
RUN tar xaf output.tar.gz
RUN install -o root -g root -m 0755 ./ripgrep-15.1.0-x86_64-unknown-linux-musl/rg /usr/local/bin/

FROM docker.io/library/buildpack-deps:trixie AS sd
WORKDIR /work
RUN curl -sSL -o output.tar.gz https://github.com/chmln/sd/releases/download/v1.1.0/sd-v1.1.0-x86_64-unknown-linux-gnu.tar.gz
RUN echo 3613eca74cd686739bb5a6d68319aa56c747e7315274d02323a2ca2b1c5d82d2 output.tar.gz | sha256sum -c
RUN tar xaf output.tar.gz
RUN install -o root -g root -m 0755 ./sd-v1.1.0-x86_64-unknown-linux-gnu/sd /usr/local/bin/

FROM mcr.microsoft.com/devcontainers/python:3.0.7-3.14-trixie
COPY --link --from=sg /usr/local/bin/ /usr/local/bin/
COPY --link --from=fd /usr/local/bin/ /usr/local/bin/
COPY --link --from=gh /usr/local/bin/ /usr/local/bin/
COPY --link --from=glab /usr/local/bin/ /usr/local/bin/
COPY --link --from=jq  /usr/local/bin/ /usr/local/bin/
COPY --link --from=rg /usr/local/bin/ /usr/local/bin/
COPY --link --from=sd /usr/local/bin/ /usr/local/bin/
USER vscode
RUN curl -fsSL https://claude.ai/install.sh | bash
