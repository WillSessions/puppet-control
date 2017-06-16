#!/usr/bin/env bash

# Install python pip and credstash depedencies
for  i in gcc python-devel python-pip openssl-devel; do
  if ! rpm --quiet -qi $i; then
    yum -y install $i
  fi
done

# Install credstash
if ! [ -x /bin/credstash ]; then
  pip install credstash
fi
