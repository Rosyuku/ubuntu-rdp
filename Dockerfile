FROM ubuntu:18.04
LABEL maintainer="KW_Rosyuku (https://twitter.com/KW_Rosyuku)"
LABEL version="0.1.2"
LABEL discription="リモートデスクトップ接続とSSH接続が可能なUbuntu:18.04のコンテナです。"

ARG host_name="Challenger"
ENV DEBIAN_FRONTEND=noninteractive \
    HOSTNAME=$host_name

#Locale and Language setting
RUN apt-get update && \
    apt-get install -y ibus-mozc language-pack-ja-base language-pack-ja fonts-takao
ARG Use_Language="ja_JP.UTF-8"
ARG Use_TimeZone="Asia/Tokyo"
ENV LANG=$Use_Language \
    TZ=$Use_TimeZone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone && \
    locale-gen $LANG && \
    echo LANG=$LANG >> /etc/default/locale

#User setting
ARG root_password="super"
ARG user_name="my-ubuntu"
ARG user_password="my-Password"
RUN echo root:$root_password | chpasswd && \
    apt-get update && apt-get install -y openssl sudo && \
    useradd -m -G sudo $user_name -p $(openssl passwd -1 $user_password) --shell /bin/bash

#RDP setting
RUN apt-get update && \
    apt-get install -y xfce4 xfce4-terminal xfce4-goodies xrdp && \
    adduser xrdp ssl-cert && \
    update-alternatives --set x-terminal-emulator /usr/bin/xfce4-terminal.wrapper
COPY ./config/xrdp/sesman.ini /etc/xrdp/sesman.ini
COPY ./config/xrdp/xrdp.ini /etc/xrdp/xrdp.ini
COPY ./config/xrdp/default.pa /etc/xrdp/pulse/default.pa
EXPOSE 3389

#SSH setting
RUN apt-get update && \
    apt-get install -y openssh-server && mkdir /var/run/sshd
COPY ./config/ssh/sshd_config /etc/ssh/sshd_config
COPY ./config/ssh/hosts.allow /etc/hosts.allow
COPY ./config/ssh/.ssh/id_rsa.pub /home/$user_name/.ssh/authorized_keys
EXPOSE 22

#Startup setting
RUN apt-get update && \
    apt-get install -y supervisor
ADD ./config/supervisord/* /etc/supervisor/conf.d/

#Install Preferred package
RUN apt-get update && \
    apt-get install -y \
    git tig gedit nano \
    wget curl net-tools firefox\
    build-essential software-properties-common

# Clean up
RUN apt-get clean && apt-get autoremove && \
    rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

CMD ["bash", "-c", "/usr/bin/supervisord -c /etc/supervisor/supervisord.conf"]