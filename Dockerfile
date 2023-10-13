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
    
RUN useradd -m -d /home/anon anon

WORKDIR /home/anon

# Add TOR browser
RUN mkdir /home/anon/Downloads && \
    chown -R anon:anon /home/anon/
USER anon

RUN git clone https://aur.archlinux.org/tor-browser-bin.git /home/anon/tor-browser
    #gpg --receive-keys D1483FA6C3C07136 && \
    #sed -i 's~dist.torproject.org/torbrowser~archive.torproject.org/tor-package-archive/torbrowser~g' PKGBUILD && \
WORKDIR /home/anon/tor-browser
#RUN sed -i -e "s/pkgver='12.5.6'/pkgver='13.0'/g" PKGBUILD
RUN rm PKGBUILD && \
    wget "https://raw.githubusercontent.com/Elrondo46/arch-torbrowserfr/master/PKGBUILD"
RUN makepkg --skippgpcheck -s 
USER root

RUN pacman -U --noconfirm /home/anon/tor-browser/*.pkg.tar.zst && \
    pacman -Scc --noconfirm && \
    rm -rf /home/anon/* 

USER anon
RUN mkdir /home/anon/Downloads
RUN pulseaudio --fail --daemonize --start && \
    pactl load-module module-null-sink

CMD tor-browser

