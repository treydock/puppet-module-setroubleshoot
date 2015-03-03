# Private class
class setroubleshoot::params {

  $setroubleshoot_configs         = {}
  $email_recipients               = {}

  case $::osfamily {
    'RedHat': {
      $package_name               = 'setroubleshoot-server'
      $config_path                = '/etc/setroubleshoot/setroubleshoot.conf'
      $email_recipients_filepath  = '/var/lib/setroubleshoot/email_alert_recipients'
      $email_smtp_port            = '25'
      $email_smtp_host            = 'localhost'
      $email_from_address         = 'SELinux_Troubleshoot'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
