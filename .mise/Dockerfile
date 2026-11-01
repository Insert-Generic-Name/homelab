FROM ghcr.io/jdx/mise:2026.10.4-debian

WORKDIR /src

COPY . ./.mise

# Load config.ci.toml
ENV MISE_ENV="ci"

RUN mise trust && mise install --locked --verbose

