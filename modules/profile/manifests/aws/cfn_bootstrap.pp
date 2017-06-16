class profile::aws::cfn_bootstrap (
  String $version = '1.4',
){

  archive { '/root/aws-cfn-bootstrap-latest.tar.gz':
    ensure       => present,
    extract      => true,
    extract_path => '/root',
    source       => 'https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz',
    creates      => "/root/aws-cfn-bootstrap-${version}",
    cleanup      => true,
  }

  exec { 'python-build-cfn-bootstrap':
    path    => '/bin:/usr/bin:/usr/local/bin',
    command => 'python setup.py build',
    cwd     => "/root/aws-cfn-bootstrap-${version}",
    creates => '/bin/cfn-signal',
    require => Archive['/root/aws-cfn-bootstrap-latest.tar.gz'],
    notify  => Exec['python-install-cfn-bootstrap'],
  }

  exec { 'python-install-cfn-bootstrap':
    path        => '/bin:/usr/bin:/usr/local/bin',
    command     => 'python setup.py install',
    cwd         => "/root/aws-cfn-bootstrap-${version}",
    refreshonly => true,
  }

}
