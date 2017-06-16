class profile::telegraf (
  Hash  $global_tags  = {},
  Hash  $inputs       = {},
  Hash  $outputs      = {},
) {

  if has_key($facts, 'packer_builder_type') {
    $service_ensure = 'stopped'
  } else {
    $service_ensure = 'running'
  }
  class { 'telegraf':
    global_tags    => $global_tags,
    inputs         => $inputs,
    outputs        => $outputs,
    service_ensure => $service_ensure,
  }

}
