#!/bin/bash -ex

apt-get update
apt-get install --no-install-recommends -y bison build-essential curl flex git gnupg gperf libesd0-dev libncurses5-dev libsdl1.2-dev libwxgtk2.8-dev libxml2 libxml2-utils lzop phablet-tools pngcrush schedtool squashfs-tools xsltproc zip zlib1g-dev g++-multilib gcc-multilib lib32ncurses5-dev lib32readline-gplv2-dev lib32z1-dev software-properties-common debconf-utils unzip openjdk-7-jdk openjdk-7-jre
apt-get install --no-install-recommends -y libbcprov-java libbcpkix-java libasm4-java

git config --global user.email "guest@guest.com"
git config --global user.name "guest"

apt-get clean
