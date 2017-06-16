class profile::base (
  Hash  $cloudwatch_logs  = {},
  Hash  $pips             = {},
) {

  include ::stdlib

  $pip_defaults = {
    ensure  => present,
    require => Class['::python'],
  }

  $binaries = [ 'git', 'gcc', 'openssl-devel' ]

  package { $binaries:
    ensure => present,
    before => Python::Pip['credstash'],
  }

  class { '::python':
    dev     => present,
  }
  contain ::python

  create_resources(::python::pip, $pips, $pip_defaults)

  if $::environment != 'vagrant' {
    unless has_key($facts, 'packer_builder_type') {
      create_resources('cloudwatchlogs::log', $cloudwatch_logs)
    }
  }

}
