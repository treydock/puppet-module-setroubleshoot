# Private class
class setroubleshoot::install {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  package { 'setroubleshoot':
    ensure => $setroubleshoot::package_ensure_real,
    name   => $setroubleshoot::params::package_name,
    notify => $setroubleshoot::package_notify,
  }

}
