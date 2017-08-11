FROM ubuntu:17.10

MAINTAINER LyTeFaST

ENV DEBIAN_FRONTEND=noninteractive
# Packages
RUN apt update && \
    apt install -y \
        bash \
        openssh-client \
        vim && \
    apt clean && \
    apt autoremove && \
    rm -fr /var/cache/apt/archives/*

ADD .ssh /root/.ssh

ADD ./entrypoint.sh /bin/entrypoint.sh
RUN chmod +x /bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
