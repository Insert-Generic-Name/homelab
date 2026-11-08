FROM alpine:3.24

# mise must be installed inside $PATH
RUN apk add curl && \
    curl -fsSL https://mise.run | \
    MISE_INSTALL_PATH="/usr/local/bin/mise" \
    MISE_VERSION=v2026.10.4 sh

WORKDIR /mise

COPY config.ci.toml mise.ci.lock .mise/

# Configure mise to target CI environment
ENV MISE_ENV="ci"

RUN addgroup mise && \
    adduser -S -G mise mise && \
    chown -R mise:mise .

USER mise

RUN mise trust && mise install --locked --verbose
slop