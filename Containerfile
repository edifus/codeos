# ublue-os/bazzite-nvidia-open:42.20250522.1
ARG BUILD_DIGEST="sha256:f5599be0a559fe52a7aa92dd7a44919adeb58c07834ee588b3672fbac94d5889"

FROM scratch AS ctx
COPY build_files /

FROM ghcr.io/ublue-os/bazzite-nvidia-open@${BUILD_DIGEST} AS codeos
COPY system_files /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
  --mount=type=cache,dst=/var/cache \
  --mount=type=cache,dst=/var/log \
  --mount=type=tmpfs,dst=/tmp \
  /ctx/install-apps.sh && \
  /ctx/fix-opt.sh && \
  /ctx/build-initramfs.sh && \
  /ctx/cleanup.sh
