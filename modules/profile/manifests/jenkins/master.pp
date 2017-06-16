class profile::jenkins::master (
  Hash                  $config_hash             = {},
  Hash                  $jobs                    = {},
  Hash                  $pips                    = {},
  Hash                  $plugins                 = {},
  Hash                  $ssh_host_keys           = {},
  Variant[String, Hash] $ssh_private_key         = '',
  String                $ssh_public_key          = '',
  String                $ssl_ca_crt              = '',
  String                $ssl_crt                 = '',
  Variant[String,Hash]  $ssl_private_key         = '',
  Hash                  $sysconfig_hash          = {},
) inherits profile::jenkins {

  include ::stdlib

  $pip_defaults = {
    ensure  => present,
    require => Class['python'],
  }

  $binaries = [ 'git', 'openssl-devel' ]

  package { $binaries:
    ensure => present,
    before => Python::Pip['credstash'],
  }

  class { 'python':
    dev     => present,
  }
  contain ::python

  create_resources(::python::pip, $pips, $pip_defaults)

  [$ssh_private_key, $ssl_private_key].each |$key| {
    if $key.is_a(Hash) {
      if ! has_key($key, 'provider') {
        fail("'provider' key name not found in \$ssh_private_key Hash variable.")
      }

      if ! member(['credstash', 'file'], $key['provider']) {
        fail("\$ssh_private_key['provider'] accepts values 'credstash' or 'file' only.")
      }

      if $key['provider'] == 'credstash' {
        if ! has_key($key, 'credential') {
          fail("'credential' key name not found \$ssh_private_key Hash variable.")
        }
      } else {
        if ! has_key($key, 'path') {
          fail("'path' key name not found \$ssh_private_key Hash variable.")
        }
      }
    }
  }

  if $ssh_private_key.is_a(Hash) {
    $ssh_private_key_content = $ssh_private_key['provider'] ? {
      'credstash' => get_credential($ssh_private_key['credential']),
      'file'      => file($ssh_private_key['path']),
    }
  } else {
    $ssh_private_key_content = $ssh_private_key
  }

  if $ssl_private_key.is_a(Hash) {
    $ssl_private_key_content = $ssl_private_key['provider'] ? {
      'credstash' => get_credential($ssl_private_key['credential']),
      'file'      => file($ssl_private_key['path']),
    }
  } else {
    $ssl_private_key_content = $ssl_private_key
  }

  class { 'jenkins':
    config_hash     => $config_hash,
    jobs            => $jobs,
    plugins         => $plugins,
    ssh_host_keys   => $ssh_host_keys,
    ssh_private_key => $ssh_private_key_content,
    ssh_public_key  => $ssh_public_key,
    ssl_ca_crt      => $ssl_ca_crt,
    ssl_crt         => $ssl_crt,
    ssl_private_key => $ssl_private_key_content,
    sysconfig_hash  => $sysconfig_hash,
  }

  file { '/usr/local/bin/check_jenkins.rb':
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('profile/jenkins/check_jenkins.rb.erb'),
    require => Class['::jenkins'],
  }

  ::consul::service { 'jenkins':
    name    => 'jenkins',
    port    => $::jenkins::port,
    checks  => [
      {
        script   => 'sudo /usr/local/bin/check_jenkins.rb',
        interval => '10s',
        timeout  => '1s',
      }
    ],
    require => File['/usr/local/bin/check_jenkins.rb'],
  }

}
