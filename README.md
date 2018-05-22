# puppet-module-hosts

Manage host entries.

Can ensure host entries for localhost, localhost6, and $::fqdn, including
aliases, arbitrary hosts and optionally purge unmanaged entries.

# Compatibility

This module is built for use with Puppet v4 and v5 with the ruby
versions that they are packaged with. See `.travis.yml` for the exact
matrix. The module is functionality tested with Vagrant. Please see the
`Vagrantfile` for a list of those platforms.

It should work with any \*nix based system that uses `/etc/hosts`.
It should also work with any system that the puppet `host` type supports.


# Documented with Puppet Strings

[Puppet Strings documentation](http://ghoneycutt.github.io/ghoneycutt-hosts/doc/puppet_classes/hosts.html)

===

# Hiera example of host_entries
```yaml
---
hosts::host_entries:
  'servicename.example.com':
    ip: '10.0.0.5'
    host_aliases:
      - 'servicename'
```
