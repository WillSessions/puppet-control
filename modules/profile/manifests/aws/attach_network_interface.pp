class profile::aws::attach_network_interface {

  # Default attributes for 'file' resource type
  File {
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    before => Service['NetworkManager'],
    notify => Service['NetworkManager'],
  }

  file { "/etc/sysconfig/network-scripts/ifcfg-eth${::eni_device_index}":
    content => template('profile/aws/ifcfg-eth.erb'),
  }

  file { '/etc/sysconfig/network':
    content => template('profile/aws/network.erb'),
  }

  file { '/etc/iproute2/rt_tables':
    content => template('profile/aws/rt_tables.erb'),
  }

  file { "/etc/sysconfig/network-scripts/route-eth${::eni_device_index}":
    content => template('profile/aws/route-eth.erb'),
  }

  file { "/etc/sysconfig/network-scripts/rule-eth${::eni_device_index}":
    content => template('profile/aws/rule-eth.erb'),
  }

  file { '/etc/NetworkManager/dispatcher.d/100-setuproutes':
    mode    => '0755',
    content => template('profile/aws/100-setuproutes.erb'),
  }

  service { 'NetworkManager':
    ensure => running,
    enable => true,
  }

}
