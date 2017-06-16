#!/bin/bash

# Install gem dependency packages
for  i in gcc zlib-devel; do
  if ! rpm --quiet -qi $i; then
    yum -y install $i
  fi
done

# Install ruby gems
for i in nokogiri; do
  if ! ls /opt/puppetlabs/puppet/lib/ruby/gems/2.1.0/specifications | grep -q $i-; then
    /opt/puppetlabs/puppet/bin/gem install $i --no-ri --no-rdoc
  fi
done
