class profile::puppet::agent (
  $config_hash    = {},
  $external_facts = {},
) {

  class { '::puppet':
    config_hash    => $config_hash,
    external_facts => $external_facts,
  }

}
