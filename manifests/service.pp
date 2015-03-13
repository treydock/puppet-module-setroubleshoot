# Private class
class setroubleshoot::service {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $setroubleshoot::manage_services and $setroubleshoot::ensure == 'present' {
    service { 'messagebus':
      ensure => 'running',
      enable => true,
    }->
    service { 'auditd':
      ensure   => 'running',
      enable   => true,
      provider => 'redhat',
    }
  }

}
