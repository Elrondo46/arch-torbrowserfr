FROM archlinux:base

RUN sed -i 's/^CheckSpace/#CheckSpace/g' /etc/pacman.conf

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

RUN sed -i "s/#fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/g" /etc/locale.gen
RUN locale-gen
RUN useradd -m -d /home/anon anon

WORKDIR /home/anon

# Add TOR browser
RUN mkdir /home/anon/Downloads && \
    chown -R anon:anon /home/anon/
USER anon

RUN git clone https://aur.archlinux.org/tor-browser.git /home/anon/tor-browser
    #gpg --receive-keys D1483FA6C3C07136 && \
    #sed -i 's~dist.torproject.org/torbrowser~archive.torproject.org/tor-package-archive/torbrowser~g' PKGBUILD && \
WORKDIR /home/anon/tor-browser
RUN sed -i -e "s/tor-browser-linux64-12.0_fr.tar.xz/tor-browser-linux64-12.0_ALL.tar.xz/g" PKGBUILD
RUN makepkg --skippgpcheck -s 
USER root

RUN pacman -U --noconfirm /home/anon/tor-browser/*.pkg.tar.zst && \
    pacman -R --noconfirm gcc fakeroot sudo git && \
    pacman -Scc --noconfirm && \
    rm -rf /home/anon/* 

USER anon
RUN mkdir /home/anon/Downloads
RUN pulseaudio --fail --daemonize --start && \
    pactl load-module module-null-sink
RUN export LANG=fr_FR.UTF-8
CMD LANGUAGE=fr_FR && tor-browser

