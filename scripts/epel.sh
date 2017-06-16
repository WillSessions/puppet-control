#!/usr/bin/env bash

cat << EOF > /etc/yum.repos.d/epel.repo
[epel]
name=Extra Packages for Enterprise Linux 7 - \$basearch
mirrorlist=https://mirrors.fedoraproject.org/mirrorlist?repo=epel-7&arch=\$basearch
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7
failovermethod=priority
EOF

rpm --import https://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7
