#!/bin/bash

# Install package repo
if ! rpm --quiet -qi puppetlabs-release-pc1; then
  sudo rpm -Uvh https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm
fi

# Install and configure Puppet agent
if ! rpm --quiet -qi puppet-agent; then
  yum -y install puppet-agent-$1
fi


# Install Ruby gems for Puppet server and agent
for i in aws-sdk; do
  if ! ls /opt/puppetlabs/puppet/lib/ruby/gems/2.1.0/specifications | grep -q $i-; then
    /opt/puppetlabs/puppet/bin/gem install $i --no-ri --no-rdoc
  fi
done
