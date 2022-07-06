#!/bin/sh

set -e

# Basic setup
export DEBIAN_FRONTEND=noninteractive
export LC_ALL=C.UTF-8

cat > /etc/apt/apt.conf.d/01_norecommend.conf <<EOF
APT::Install-Recommends "0";
APT::Install-Suggests "0";
EOF

# Grab LTS security updates and newer HTTPS certificates
echo "deb http://security.debian.org/ stretch/updates main" >> /etc/apt/sources.list
apt-get update && apt-get upgrade -y --with-new-pkgs
apt-get autoremove --purge -y

# Toolchain and not self-built libs
# to build libass-deps from tarballs
# and libass itself from git
apt-get install -y \
    sudo bash curl ca-certificates tar gzip bzip2 \
    make gcc g++ pkg-config libexpat1-dev \
    nasm libtool libpng-dev \
    libubsan0 libasan3 \
    git automake1.11 autoconf2.64
apt-get clean

# Default to older autoconf and automake versions
for i in aclocal automake ; do
    ln -s /usr/bin/"$i"-1.11 /usr/local/bin/"$i"
done
for i in autoconf autoheader autom4te autoreconf autoscan ; do
    ln -s /usr/bin/"$i"2.64 /usr/local/bin/"$i"
done

# Setup user with matching UID, passwordless sudo and directory for GHA
groupadd -g 1001 runner
useradd -m -d /home/runner -s /bin/bash -g runner -G sudo -u 1001 runner
runuser -u runner mkdir /home/runner/work

sed -i -e '/^%sudo[ \t]/d' /etc/sudoers
printf '%%sudo\tALL=(ALL:ALL)\tNOPASSWD:ALL\n' | EDITOR='tee -a' visudo
