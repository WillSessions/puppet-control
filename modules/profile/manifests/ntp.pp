class profile::ntp (
  Boolean $disable_dhclient = true,
  Boolean $iburst_enable    = true,
  Array   $interfaces       = [ $::ec2_metadata['network']['interfaces']['macs'][$::networking['interfaces']['eth1']['mac']]['local-ipv4s'] ],
  Hash    $restrict         = {},
) {

  include ::stdlib

  $restrict_defaults = [
    'default kod nomodify notrap nopeer noquery',
    '-6 default kod nomodify notrap nopeer noquery',
    '127.0.0.1',
    '-6 ::1',
  ]

  $restrict_merged = assert_type(Array[String], $restrict_defaults + $restrict[$::aws_region['code']])

  class { '::ntp':
    disable_dhclient => $disable_dhclient,
    iburst_enable    => $iburst_enable,
    interfaces       => $interfaces,
    restrict         => $restrict_merged,
  }

}
