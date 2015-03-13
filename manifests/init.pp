# == Class: setroubleshoot
#
# === Authors
#
# Trey Dockendorf <treydock@gmail.com>
#
# === Copyright
#
# Copyright 2015 Trey Dockendorf
#
class setroubleshoot (
  $ensure                     = 'present',
  $manage_services            = true,
  $package_ensure             = undef,
  $package_name               = $setroubleshoot::params::package_name,
  $config_path                = $setroubleshoot::params::config_path,
  $email_recipients_filepath  = $setroubleshoot::params::email_recipients_filepath,
  $email_smtp_port            = $setroubleshoot::params::email_smtp_port,
  $email_smtp_host            = $setroubleshoot::params::email_smtp_host,
  $email_from_address         = $setroubleshoot::params::email_from_address,
  $setroubleshoot_configs     = $setroubleshoot::params::setroubleshoot_configs,
  $email_recipients           = $setroubleshoot::params::email_recipients,
) inherits setroubleshoot::params {

  validate_bool(
    $manage_services,
  )

  validate_string(
    $package_name,
    $config_path,
    $email_recipients_filepath,
    $email_smtp_port,
    $email_smtp_host,
    $email_from_address
  )

  validate_hash(
    $setroubleshoot_configs,
    $email_recipients
  )

  case $ensure {
    'present': {
      $package_ensure_default = 'present'
    }
    'absent': {
      $package_ensure_default = 'absent'
    }
    default: {
      fail("Module ${module_name}: ensure parameter must be present or absent")
    }
  }

  $package_ensure_real = pick($package_ensure, $package_ensure_default)

  if $manage_services {
    $package_notify = Service['auditd']
  } else {
    $package_notify = undef
  }

  include setroubleshoot::install
  include setroubleshoot::config
  include setroubleshoot::service

  anchor { 'setroubleshoot::start': }->
  Class['setroubleshoot::install']->
  Class['setroubleshoot::config']->
  Class['setroubleshoot::service']->
  anchor { 'setroubleshoot::end': }

}
