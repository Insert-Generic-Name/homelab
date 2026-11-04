FROM ghcr.io/jdx/mise:2026.10.4-debian

WORKDIR /src

COPY config.ci.toml mise.ci.lock ./.mise

# Configure mise to target CI environment
ENV MISE_ENV="ci"

RUN mise trust && mise install --locked --verbose

#trig
