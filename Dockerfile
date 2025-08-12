# Dockerfile - GoTTY for Render (alpine, small, downloads release binary)
ARG GOTTY_VERSION=v1.0.1
FROM alpine:3.20

# install minimal runtime deps
RUN apk add --no-cache bash curl ca-certificates sudo \
    && update-ca-certificates

# download gotty prebuilt binary (fixed extraction)
ARG GOTTY_VERSION
RUN curl -fSL "https://github.com/yudai/gotty/releases/download/${GOTTY_VERSION}/gotty_linux_amd64.tar.gz" \
    -o /tmp/gotty.tar.gz \
 && tar -xzf /tmp/gotty.tar.gz -C /tmp \
 && mv /tmp/gotty /usr/local/bin/gotty \
 && chmod +x /usr/local/bin/gotty \
 && rm -rf /tmp/gotty.tar.gz


# Create a non-root user and give passwordless sudo (so you can run `sudo` from the web shell)
ARG GOTTY_USER=gotty
RUN addgroup -S ${GOTTY_USER} \
    && adduser -S -G ${GOTTY_USER} -s /bin/bash ${GOTTY_USER} \
    && echo "${GOTTY_USER} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${GOTTY_USER} \
    && chmod 0440 /etc/sudoers.d/${GOTTY_USER}

# copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh && chown ${GOTTY_USER}:${GOTTY_USER} /entrypoint.sh

WORKDIR /home/${GOTTY_USER}
USER ${GOTTY_USER}
ENV HOME=/home/${GOTTY_USER}

# EXPOSE is informational; Render detects the listening port. Keep default 8080.
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
