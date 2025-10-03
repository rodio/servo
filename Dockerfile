FROM ubuntu:22.04 AS bootstrap

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC 

COPY --from=ghcr.io/astral-sh/uv:0.8.22 /uv /uvx /bin/

WORKDIR /root/src/servo

RUN \
  --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
  --mount=target=/var/cache/apt,type=cache,sharing=locked \
  --mount=target=/root/.rustup,type=cache,sharing=locked \
  --mount=target=/root/.cargo,type=cache,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean \
    && echo 'APT::Get::Assume-Yes "true";' > /etc/apt/apt.conf.d/90forceyes \
    && echo 'APT::Get::force-yes "true";' >> /etc/apt/apt.conf.d/90forceyes \
    && apt-get update \
    && apt-get --no-install-recommends install ca-certificates curl \
    && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain none
ENV PATH="/root/.cargo/bin:${PATH}"

# these are the files needed for the bootstrap and tests
COPY mach .python-version Cargo.lock Cargo.toml pyproject.toml rust-toolchain.toml .
COPY python ./python
COPY support ./support
COPY tests ./tests
COPY resources ./resources

RUN \
  --mount=target=/root/src/servo/target,type=cache,sharing=locked \
  --mount=target=/root/src/servo/support/crown/target,type=cache,sharing=locked \
  --mount=target=/var/lib/apt/lists,type=cache,sharing=locked \
  --mount=target=/var/cache/apt,type=cache,sharing=locked \
  --mount=target=/root/.rustup,type=cache,sharing=locked \
  --mount=target=/root/.cargo,type=cache,sharing=locked \
  --mount=target=/root/.cache/uv,type=cache,sharing=locked\
    ./mach bootstrap --skip-lints
