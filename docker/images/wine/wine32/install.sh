#!/bin/bash
set -ex

BASE_TOOLS="p7zip-full nano git subversion patch"
DEV_TOOLS="flex bison make gcc:i386 prelink:i386 libpng-dev:i386 libx11-dev:i386 libxml2-dev:i386 libxslt-dev:i386 libfreetype6-dev:i386 libgnutls-dev:i386 libncurses5-dev:i386 libncursesw5-dev:i386"

dpkg --add-architecture i386
apt-get update
apt-get install -y --no-install-recommends $BASE_TOOLS $DEV_TOOLS libx11-6:i386 libxml2:i386 libxslt1.1:i386 libfreetype6:i386 libgnutls-openssl27:i386 libgnutlsxx27:i386 libncurses5:i386 libncursesw5:i386 wget ca-certificates xvfb winbind xauth

git clone git://source.winehq.org/git/wine /tmp/wine
cd /tmp/wine
./configure --without-gettext --without-jpeg --without-alsa --without-coreaudio --without-oss --without-xrender --without-opengl
make install

wine --version

wget -O /usr/sbin/winetricks http://winetricks.org/winetricks
chmod +x /usr/sbin/winetricks

# Change temp and other env vars
wine regedit /S Z:\\tmp\\vars.reg

# Apply changes
wineboot -s

# Remove dev apps and temporary files
apt-get remove --purge -y $DEV_TOOLS
apt-get autoremove -y
apt-get clean
rm -rf /tmp/*

# Timeout for apply wine registry changes
sleep 5
