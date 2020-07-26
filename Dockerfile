FROM archlinux/base

RUN pacman -Syyuu --noconfirm && \
    pacman -S --noconfirm \
    wget \
    alsa-lib \
    dbus-glib \
    gawk \
    desktop-file-utils \
    file \
    gtk2 \
    gtk3 \
    hicolor-icon-theme \
    hunspell \
    icu \
    libevent \
    libvpx \
    libxt \
    mime-types \
    mozilla-common \
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

RUN git clone https://aur.archlinux.org/tor-browser.git && \
    cd /home/anon/tor-browser && \
    #gpg --receive-keys D1483FA6C3C07136 && \
    sed -i "s/dist/archive/g" \
    TORBROWSER_PKGLANG='fr' makepkg --skippgpcheck -s 
USER root

RUN pacman -U --noconfirm /home/anon/tor-browser/tor-browser-9.5.1-1-x86_64.pkg.tar.xz && \
    pacman -R --noconfirm gcc fakeroot sudo git && \
    pacman -Scc --noconfirm && \
    rm -rf /home/anon/* 

USER anon
RUN mkdir /home/anon/Downloads
RUN pulseaudio --fail --daemonize --start && \
    pactl load-module module-null-sink
CMD tor-browser

