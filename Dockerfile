# tini
FROM --platform=${BUILDPLATFORM} alpine:3.22 as tini
LABEL maintainer="info@pascaliske.dev"

# environment
ARG TINI_VERSION=v0.19.0
ARG TARGETPLATFORM

# install tini
RUN case ${TARGETPLATFORM} in \
    "linux/amd64")  TINI_ARCH=amd64  ;; \
    "linux/arm64")  TINI_ARCH=arm64  ;; \
    "linux/arm/v7") TINI_ARCH=armhf  ;; \
    esac \
    && wget -q https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-${TINI_ARCH} -O /tini \
    && chmod +x /tini

# final image
FROM alpine:3.22
LABEL maintainer="info@pascaliske.dev"

# environment
ARG SYNC_REPO
ARG SYNC_BRANCH
ENV GITSYNC_REPO=${SYNC_REPO}
ENV GITSYNC_REF=${SYNC_BRANCH}
ENV GITSYNC_ROOT=/config-sync
ENV GITSYNC_LINK=${SYNC_BRANCH}
ENV GITSYNC_MAX_FAILURES=3

# install git
RUN apk add --no-cache git

# inject built files
COPY --from=tini /tini /sbin/tini
COPY --from=registry.k8s.io/git-sync/git-sync:v4.4.2 /git-sync /sbin/git-sync

# inject entrypoint
COPY docker-entrypoint.sh /docker-entrypoint.sh

# let's go!
ENTRYPOINT [ "/sbin/tini", "--", "/docker-entrypoint.sh" ]
CMD [ "/sbin/git-sync" ]
