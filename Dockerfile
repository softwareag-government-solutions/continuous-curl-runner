# define the base image to create this image from
######################################################################################################

ARG BASE_IMAGE=redhat/ubi8-minimal
ARG BUILDER_IMAGE=redhat/ubi8

FROM $BASE_IMAGE as base

# 2. Define the builder, where we'll execute Product Installation and patching
######################################################################################################

FROM $BUILDER_IMAGE as builder

RUN true \
    && microdnf install \
         wget \
    && microdnf clean all \
    && true

ENV TINI_VERSION v0.19.0
RUN wget -P /tmp --no-check-certificate --no-cookies --quiet https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-amd64 \
    && wget -P /tmp --no-check-certificate --no-cookies --quiet https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-amd64.sha256sum \
    && cd /tmp \
    && echo "$(cat tini-amd64.sha256sum)" | sha256sum -c \
    && true

# Finalize the image
######################################################################################################

FROM base as final

LABEL org.opencontainers.image.authors="fabien.sanglier@softwareaggov.com" \
      org.opencontainers.image.vendor="SoftwareAG Government Solutions" \
      org.opencontainers.image.title="continuous-curl-runner" \
      org.opencontainers.image.description="A simple runner to execute curl requests from a list of possible requests" \
      org.opencontainers.image.version="" \
      org.opencontainers.image.source="" \
      org.opencontainers.image.url="" \
      org.opencontainers.image.documentation=""

ENV REQUESTS_JSON_FILE=""
ENV REQUESTS_JSON=""
ENV REQUESTS_INTERVAL=""
ENV REQUESTS_SELECTION="random"
ENV CURL_OPTS=""

RUN true \
    && microdnf install \
         jq \
         gettext \
         bc \
    && microdnf clean all \
    && true

COPY scripts/entrypoint.sh /entrypoint.sh
COPY scripts/curl_requests.sh /curl_requests.sh

COPY --from=builder /tmp/tini-amd64 /tini
RUN chmod +x /tini

WORKDIR /

RUN chmod a+x entrypoint.sh curl_requests.sh

ENTRYPOINT ["/tini", "--", "/entrypoint.sh"]