FROM alpine:3

ARG TARGETARCH
ARG ZIG_VERSION=0.15.2

RUN set -eux; \
    case "${TARGETARCH}" in \
        amd64) ZIG_ARCH="x86_64" ;; \
        arm64) ZIG_ARCH="aarch64" ;; \
        *) echo "Unsupported architecture: ${TARGETARCH}" >&2; exit 1 ;; \
    esac; \
    apk add --no-cache --virtual .build-deps \
        curl \
    ; \
    curl -fSL "https://ziglang.org/download/${ZIG_VERSION}/zig-${ZIG_ARCH}-linux-${ZIG_VERSION}.tar.xz" \
        -o /tmp/zig.tar.xz; \
    mkdir -p /usr/local/zig; \
    tar -xJf /tmp/zig.tar.xz -C /usr/local/zig --strip-components=1; \
    rm /tmp/zig.tar.xz; \
    apk del .build-deps

ENV PATH="/usr/local/zig:${PATH}"

CMD ["zig", "version"]
