#!/bin/bash
# Build nqptp + shairport-sync (AirPlay 2) from source, 2026-10-05.
set -euo pipefail; export LC_ALL=C DEBIAN_FRONTEND=noninteractive
echo "== deps $(date +%T)"
sudo -n -E apt-get install -y -qq --no-install-recommends build-essential git autoconf automake libtool \
  libpopt-dev libconfig-dev libasound2-dev avahi-daemon libavahi-client-dev libssl-dev libsoxr-dev \
  libplist-dev libsodium-dev libavutil-dev libavcodec-dev libavformat-dev uuid-dev libgcrypt20-dev xxd libplist-utils systemd-dev >/dev/null
for r in nqptp shairport-sync; do
  [ -d ~/$r ] || git clone -q https://github.com/mikebrady/$r.git ~/$r
  cd ~/$r; git fetch -q --tags; t=$(git describe --tags --abbrev=0 origin/HEAD 2>/dev/null || git describe --tags --abbrev=0); git checkout -q "$t"; echo "== $r at $t $(date +%T)"
done
cd ~/nqptp; autoreconf -fi >/dev/null 2>&1; ./configure --with-systemd-startup >/dev/null; make -s >/dev/null; sudo -n make install >/dev/null
echo "== nqptp installed $(date +%T)"
cd ~/shairport-sync; autoreconf -fi >/dev/null 2>&1
SYSTEMD_FLAG=--with-systemd-startup; ./configure --help | grep -q -- "--with-systemd-startup" || SYSTEMD_FLAG=--with-systemd
./configure --sysconfdir=/etc --with-alsa --with-avahi --with-ssl=openssl --with-metadata --with-soxr $SYSTEMD_FLAG --with-airplay-2 >/dev/null
echo "== shairport-sync configured ($SYSTEMD_FLAG), compiling $(date +%T)"
make -s -j2 >/dev/null 2>&1 || make -s >/dev/null
sudo -n make install >/dev/null
echo "== shairport-sync installed $(date +%T)"; /usr/local/bin/shairport-sync -V
echo BUILD_DONE
