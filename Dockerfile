FROM ubuntu:16.04
MAINTAINER David Nunez <david.nunez@galaxysemi.com>

# Make sure we're using the proper terminal environment
RUN rm /bin/sh && ln -s /bin/bash /bin/sh
ENV TERM xterm

# Update the repos available
RUN apt-get -yqq update
RUN apt-get -yqq upgrade

# Base dependencies 
RUN apt-get install -yqq \
    build-essential \
    curl \
    git \
    jq \
    man \
    net-tools \
    openssh-server \
    pwgen \
    sudo \
    vim \
    wget

# Install Java
RUN apt-get -yqq install openjdk-8-jre-headless

# Dependencies related to VNC/X11 remote window capabilities
RUN apt-get install -yqq \
    fluxbox \
    xvfb \
    supervisor \
    x11vnc

# Web-based VNC client option
RUN git clone https://github.com/kanaka/noVNC.git

# Create the default user and set their privileges
RUN useradd ubuntu --shell /bin/bash --create-home
RUN usermod -a -G sudo ubuntu

RUN mkdir -p /home/ubuntu/.vnc
RUN mkdir -p /var/run/sshd

# This overlay folder contains configuration settings for internal tools (like supervisord)
COPY docker /

# VNC and Web browsable ports exposed
EXPOSE 9595 5900 22

# Run vnc through supervisord
CMD ["/usr/bin/start"]