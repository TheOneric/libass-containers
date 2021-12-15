FROM docker.io/library/debian:stretch-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LC_ALL=C.UTF-8

COPY setup_root.sh /
RUN /bin/dash setup_root.sh
RUN /bin/rm /setup_root.sh

COPY build.sh /
RUN /bin/su -c '/bin/dash /build.sh' runner
RUN /bin/rm /build.sh

USER runner:runner
CMD ["/bin/sh", "-c", "echo 'This container is supposed to run custom commands or be used interactively!'"]
