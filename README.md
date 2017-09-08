# puppet-module-hosts

Manage host entries.

Can ensure host entries for localhost, localhost6, and $::fqdn, including
aliases, arbitrary hosts and optionally purge unmanaged entries.

# Compatibility

This module has been tested to work on the following systems with the
latest Puppet v3, v3 with future parser, v4, v5 and v6.  See `.travis.yml`
for the exact matrix of supported Puppet and ruby versions.

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
