# Private class
class setroubleshoot::config {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $setroubleshoot::ensure == 'present' {
    file { '/etc/setroubleshoot/setroubleshoot.conf':
      ensure => 'file',
      path   => $setroubleshoot::config_path,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }

    file { 'setroubleshoot-email_alert_recipients':
      ensure  => 'file',
      path    => $setroubleshoot::email_recipients_filepath,
      owner   => 'root',
      group   => 'root',
      mode    => '0600',
      content => template('setroubleshoot/email_alert_recipients.erb'),
    }

    setroubleshoot_config { 'email/recipients_filepath':
      value => $setroubleshoot::email_recipients_filepath,
    }

    setroubleshoot_config { 'email/smtp_port':
      value => $setroubleshoot::email_smtp_port,
    }

    setroubleshoot_config { 'email/smtp_host':
      value => $setroubleshoot::email_smtp_host,
    }

    setroubleshoot_config { 'email/from_address':
      value => $setroubleshoot::email_from_address,
    }

    create_resources('setroubleshoot_config', $setroubleshoot::setroubleshoot_configs)
  }

}
