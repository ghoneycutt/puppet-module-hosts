# puppet-module-hosts

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
1. [Setup - The basics of getting started with hosts](#setup)
   * [What hosts affects](#what-hosts-affects)
   * [Setup requirements](#setup-requirements)
   * [Beginning with hosts](#beginning-with-hosts)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This is a very simple module to manage host entries in `/etc/hosts`. It
works by applying a hash of `host` resources.

Documented with Puppet Strings at
[http://ghoneycutt.github.io/puppet-module-hosts/](http://ghoneycutt.github.io/puppet-module-hosts/).


## Setup

### What hosts affects

Generally just the `/etc/hosts` file though you may use the `target`
attribute of the `host` resource to manage host entries in other files.

### Setup requiremements

The ability to manage `/etc/hosts` was moved out of Puppet and into a
core module at
[https://github.com/puppetlabs/puppetlabs-host_core](https://github.com/puppetlabs/puppetlabs-host_core)
and this module relies upon it.

### Beginning with hosts

Declare the `hosts` class.

## Usage

The normal use case. If you are not adding the local system by default
as shown below, this is a good option. Then you can just add
`hosts::hosts` entries throughout Hiera.

```puppet
include hosts
```

Sample profile which implements functionality from previous versions.

```puppet
# Lookup everything in Hiera using the key 'host_entries' and add the
# local system with its FQDN and IP address.
$hosts = lookup('host_entries', undef, deep, {}) + {
  $facts['networking']['hostname'] => {
    ensure       => present,
    host_aliases => [$facts['networking']['fqdn']],
    ip           => $facts['networking']['ip'],
  }
}

class { 'hosts':
  hosts => $hosts,
}
```

## Limitations

This module officially supports the platforms listed in the
`metadata.json`. It does not fail on unsupported platforms and has been
known to work on many, many platforms since its creation in 2010.

## Development

See [CONTRIBUTING.md](CONTRIBUTING.md)

## License

See [LICENSE](LICENSE) file.
