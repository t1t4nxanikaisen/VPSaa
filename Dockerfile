# Minimal Alpine-based GoTTY image for Render
FROM alpine:3.20

# GoTTY version
ARG GOTTY_VERSION=v1.0.1

# Install runtime deps
RUN apk add --no-cache bash curl ca-certificates sudo \
 && update-ca-certificates

# Download and install GoTTY binary
RUN curl -fSL "https://github.com/yudai/gotty/releases/download/${GOTTY_VERSION}/gotty_linux_amd64.tar.gz" \
    -o /tmp/gotty.tar.gz \
 && tar -xzf /tmp/gotty.tar.gz -C /tmp \
 && mv /tmp/gotty /usr/local/bin/gotty \
 && chmod 755 /usr/local/bin/gotty \
 && ln -s /usr/local/bin/gotty /bin/gotty \
 && rm -rf /tmp/gotty*

# Create non-root user
ARG GOTTY_USER=gotty
RUN addgroup -S ${GOTTY_USER} \
 && adduser -S -G ${GOTTY_USER} -s /bin/bash ${GOTTY_USER} \
 && echo "${GOTTY_USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${GOTTY_USER} \
 && chmod 0440 /etc/sudoers.d/${GOTTY_USER}

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh \
 && chown ${GOTTY_USER}:${GOTTY_USER} /entrypoint.sh

WORKDIR /home/${GOTTY_USER}
USER ${GOTTY_USER}
ENV HOME=/home/${GOTTY_USER}
ENV PATH="${PATH}:/usr/local/bin"

EXPOSE 8080
ENTRYPOINT ["/entrypoint.sh"]
