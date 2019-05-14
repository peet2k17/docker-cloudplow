####################
# BASE IMAGE
####################
FROM ubuntu:16.04

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

    RUN \
        OVERLAY_VERSION=$(curl -sX GET "https://api.github.com/repos/just-containers/s6-overlay/releases/latest" | awk '/tag_name/{print $4;exit}' FS='[""]') && \
        curl -o /tmp/s6-overlay.tar.gz -L "https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-amd64.tar.gz" && \
        tar xfz  /tmp/s6-overlay.tar.gz -C /

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
