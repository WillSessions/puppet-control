class profile::aws::cloudwatch_agent {

  class { '::cloudwatchlogs':
    region => $::aws_region['name'],
  }

}
