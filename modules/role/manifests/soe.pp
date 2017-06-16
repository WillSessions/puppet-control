class role::soe inherits role {

  contain ::profile::base
  contain ::profile::hardening
  if $::environment != 'vagrant' {
    contain ::profile::aws::cfn_bootstrap
    contain ::profile::aws::cloudwatch_agent
    contain ::profile::aws::ssm_agent
    contain ::profile::telegraf
  }

}

