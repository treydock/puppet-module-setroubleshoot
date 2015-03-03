# puppet-module-setroubleshoot

[![Build Status](https://travis-ci.org/treydock/puppet-module-setroubleshoot.svg?branch=master)](https://travis-ci.org/treydock/puppet-module-setroubleshoot)

####Table of Contents

1. [Overview](#overview)
2. [Usage - Configuration options](#usage)
3. [Reference - Parameter and detailed reference to all options](#reference)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)
6. [TODO](#todo)
7. [Additional Information](#additional-information)

## Overview

This module manages SELinux troubleshoot server and enables configuration of notifications upon AVC denials.

## Usage

### setroubleshoot

The default behavior ensures the following:

* setroubleshoot-server package installed
* setroubleshoot configured

Example:

    class { 'setroubleshoot': }

To define addresses that receive AVC denial alerts:

    class { 'setroubleshoot':
      email_recipients => {
        'foo@example.com' => {
          'filter_type' => 'after_first'
        }
      }
    }

## Reference

### Classes

#### Public classes

* `setroubleshoot`: Installs and configures setroubleshoot-server.

#### Private classes

* `setroubleshoot::install`: Installs setroubleshoot-server package.
* `setroubleshoot::config`: Configures setroubleshoot.
* `setroubleshoot::params`: Sets parameter defaults based on fact values.

### Parameters

#### setroubleshoot

#####`ensure`

Sets the ensure behavior of this module.  Valid values are `present` and `absent`.
A value of `present` is default.  A value of `absent` will remove the setroubleshoot-server package.

#####`package_ensure`

setroubleshoot-server package ensure value.  Default is `undef` which determines value based on `ensure` parameter.

#####`package_name`

The setroubleshoot-server package name.  Default is `setroubleshoot-server`

#####`config_path`

The path to setroubleshoot configuration file.  Default is `/etc/setroubleshoot/setroubleshoot.conf`

#####`email_recipients_filepath`

Path of file containing email recipients for setroubleshoot.  Default is `/var/lib/setroubleshoot/email_alert_recipients`

#####`email_smtp_port`

Port used to send setroubleshoot email notifications.  Default is `25`

#####`email_smtp_host`

Host used to send setroubleshoot email notifications.  Default is `localhost`

#####`email_from_address`

From address used when sending setroubleshoot email notifications.  Default is `SELinux_Troubleshoot`

#####`setroubleshoot_configs`

A Hash that defines additional setroubleshoot_config resources.  Default is an empty Hash.

#####`email_recipients`

A Hash that defines email recipients to receive setroubleshoot notifications.  Default is an empty Hash.

The format of the hash is like the following:

    'foo@example.com' => {
      'filter_type' => 'after_first'
    }

The key is the email address and the value is a Hash containing the config options.   Currently only the option `filter_type` is supported.  If `filter_type` is not set the default value of `after_first` is used.

## Limitations

This module has been tested on:

* CentOS 6 x86_64
* CentOS 7 x86_64

### Known Issues

## Development

### Testing

Testing requires the following dependencies:

* rake
* bundler

Install gem dependencies

    bundle install

Run unit tests

    bundle exec rake test

If you have Vagrant >= 1.2.0 installed you can run system tests

    bundle exec rake beaker

## TODO

## Additional Information
