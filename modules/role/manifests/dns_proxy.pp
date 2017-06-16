class role::dns_proxy inherits role::soe {

  unless $::environment == 'vagrant' {
    contain ::profile::aws::attach_network_interface
  }
  contain ::profile::bind::forwarder
  contain ::profile::ntp

}

