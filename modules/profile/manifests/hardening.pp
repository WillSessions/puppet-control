class profile::hardening (
  Hash  $ssh_server_options = {},
  Hash  $sysctl             = {},
) {

  $file_defaults = {
    ensure => present,
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  [
    '/boot/grub2/grub.cfg',
    '/etc/cron.d',
    '/etc/crontab',
    '/etc/cron.hourly',
    '/etc/cron.daily',
    '/etc/cron.weekly',
    '/etc/cron.monthly',
  ].each |String $file| {
    file { $file:
      * => $file_defaults,
    }
  }

  class { 'sysctl::base':
    purge  => true,
    values => $sysctl,
  }

  file { $ssh_server_options['Banner']:
    content => template('profile/hardening/issue.net.erb'),
    *       => $file_defaults,
  }

  class { 'ssh':
    server_options       => $ssh_server_options,
    storeconfigs_enabled => false,
  }

  service { 'postfix':
    ensure => 'stopped',
    enable => false,
  }

}
