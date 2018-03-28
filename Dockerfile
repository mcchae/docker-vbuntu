FROM ubuntu:16.04
MAINTAINER Jerry Chae <mcchae@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# OpenGL / MESA
RUN apt-get  update \
    && apt-get install -y dbus-x11 procps psmisc \
    && apt-get install -y mesa-utils mesa-utils-extra libxv1

# set root password
RUN echo "root:r" | /usr/sbin/chpasswd

# set timezone
ENV TZ=Asia/Seoul
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Language/locale settings
ENV LANG=ko_KR.UTF-8
RUN echo "ko_KR.UTF-8 UTF-8" > /etc/locale.gen \
    && echo "LANG=ko_KR.UTF-8" > /etc/default/locale \
    && apt-get install -y locales

#COPY sources.list /etc/apt/sources.list
RUN apt-get update \
    && apt-get install -y xrdp xvfb xfce4 slim lxterminal \
        fonts-nanum fonts-nanum-coding uim uim-byeoru im-config zenity \
        git sudo dbus udev xauth supervisor firefox \
        build-essential python3 python3-dev python3-pip \
        wget tmux vim libreoffice \
    && apt-get -y upgrade \
    && apt-get -y purge xscreensaver \
    && apt-get -y autoremove \
    && apt-get clean \
    && apt-get autoclean

ADD xrdp.conf /etc/supervisor/conf.d/xrdp.conf
RUN xrdp-keygen xrdp auto

#ADD chroot/etc /etc
ADD chroot/usr /usr
ADD chroot/startup.sh /

#CMD ["supervisord", "-n"]
CMD ["bash", "/startup.sh"]
EXPOSE 3389