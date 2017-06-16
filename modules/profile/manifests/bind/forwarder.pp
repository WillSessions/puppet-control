class profile::bind::forwarder (
  Array   $allow_query        = [ 'any' ],
  String  $dnssec_enable      = 'no',
  String  $dnssec_validation  = 'no',
  Array   $forwarders         = [],
  Array   $listen_addr        = [ $::ec2_metadata['network']['interfaces']['macs'][$::networking['interfaces']['eth1']['mac']]['local-ipv4s'] ],
  Array   $listen_v6_addr     = [ 'none' ],
) {

  include ::stdlib
  include ::bind

  $vpc_cidr = assert_type(String[1], $::ec2_metadata['network']['interfaces']['macs'][$::networking['interfaces']['eth1']['mac']]['vpc-ipv4-cidr-block'])
  $vpc_network_address = assert_type(String[1], split($vpc_cidr, '/')[0])
  $amazon_dns = assert_type(String[1], split($vpc_network_address, '[.]').map |Integer $i, String $v| { if $i == 3 { Integer($v)+2 } else { $v } }.join('.'))
  $forwarders_list = empty($forwarders) ? {
    true  => [ $amazon_dns ],
    false => $forwarders,
  }
  assert_type(Array, $forwarders_list)
  $managed_ad_forwarders = split($::managed_ad_ips, ',').map |String $ip| { "${ip};" }.join(' ')
  $zones = assert_type(Hash, Hash(lookup('profile::bind::forwarder::zones', Hash, {'strategy' => 'deep'})[$::aws_region['code']].map |String $k, Array $v| { if $k =~ /^ad/ { [ $k, $v + "forwarders { ${managed_ad_forwarders} }" ] } else { [ $k, $v ]  } }))

  ::bind::server::conf { '/etc/named.conf':
    allow_query       => $allow_query,
    dnssec_enable     => $dnssec_enable,
    dnssec_validation => $dnssec_validation,
    forwarders        => $forwarders_list,
    listen_on_addr    => $listen_addr,
    listen_on_v6_addr => $listen_v6_addr,
    zones             => $zones,
  }

}
