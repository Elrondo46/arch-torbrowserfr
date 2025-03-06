FROM archlinux:base

RUN sed -i 's/^CheckSpace/#CheckSpace/g' /etc/pacman.conf

RUN pacman -Syyuu --noconfirm && \
    pacman -S --noconfirm archlinux-keyring

RUN pacman-key --init && pacman-key --populate archlinux 

RUN pacman -Syyuu --noconfirm && \
    pacman -S --noconfirm \
    base-devel \
    wget \
    gnutls \
    pango \
    alsa-lib \
    dbus-glib \
    gawk \
    desktop-file-utils \
    file \
    gtk3 \
    glibc \
    hicolor-icon-theme \
    hunspell \
    icu \
    libevent \
    libvpx \
    libxt \
    mime-types \
    nss \
    git \
    fakeroot \
    sudo \
    pulseaudio \
    gcc \
    startup-notification
    
RUN useradd -m -d /home/anon anon

WORKDIR /home/anon

# Add TOR browser
RUN mkdir /home/anon/Downloads && \
    chown -R anon:anon /home/anon/
USER anon

RUN git clone https://aur.archlinux.org/tor-browser-bin.git /home/anon/tor-browser
WORKDIR /home/anon/tor-browser
RUN sed -i -e "s/14.0.6/14.0.7/g" PKGBUILD
RUN cat PKGBUILD
RUN makepkg --skipinteg -s 
USER root

RUN pacman -U --noconfirm /home/anon/tor-browser/*.pkg.tar.zst && \
    pacman -Scc --noconfirm && \
    rm -rf /home/anon/*
RUN chown -R anon:anon /home/anon

USER anon
RUN mkdir /home/anon/Downloads
RUN pulseaudio --fail --daemonize --start && \
    pactl load-module module-null-sink

CMD tor-browser

