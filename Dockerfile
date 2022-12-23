####################
# BASE IMAGE
####################
FROM ubuntu:18.04
ARG S6_OVERLAY_VERSION=3.1.2.1

MAINTAINER prc2k10@googlemail.com <prc2k10@googlemail.com>

####################
# INSTALLATIONS
####################
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get install -y \
        curl \
        fuse \
        unionfs-fuse \
        bc \
        unzip \
        wget \
        git \
        lsof \
        ca-certificates && \
    update-ca-certificates && \
    apt-get install -y openssl && \
    sed -i 's/#user_allow_other/user_allow_other/' /etc/fuse.conf

# S6 overlay
    ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2
    ENV S6_KEEP_ENV=1

	ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
	RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz

    RUN \
        git clone https://github.com/l3uddz/cloudplow /opt/cloudplow

    RUN \
        cd /opt/cloudplow

    RUN \
        apt-get update && \
        apt-get install -y python3 \
        python3-pip

    RUN \
        python3 -m pip install -r /opt/cloudplow/requirements.txt

    RUN \
        ln -s /opt/cloudplow/cloudplow.py /usr/local/bin/cloudplow
