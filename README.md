hosts module
============

Manage host entries.

Can ensure host file entries for localhost, localhost6, $::fqdn, including
aliases, arbitrary hosts and optionally purge unmanaged entries.

[![Build Status](https://api.travis-ci.org/ghoneycutt/puppet-module-hosts.png?branch=master)](https://travis-ci.org/ghoneycutt/puppet-module-hosts)

===

# Compatibility

This module is built for use with Puppet v4 and v5 with the ruby
versions that they are packaged with. See `.travis.yml` for the exact
matrix. The module is functionality tested with Vagrant. Please see the
`Vagrantfile` for a list of those platforms.

It should work with any \*nix based system that uses `/etc/hosts`.
It should also work with any system that the puppet `host` type supports.

===

# Parameters

---
#### enable_ipv4_localhost
Boolean to enable ipv4 localhost entry

- *Default*: `true`

---
#### enable_ipv6_localhost
Boolean to enable ipv6 localhost entry

- *Default*: `true`

---
#### enable_fqdn_entry
Boolean to enable entry for fqdn

- *Default*: `true`

---
#### localhost_name
Host name entry for 127.0.0.1 (should be fqdn)

- *Default*: `'localhost.localdomain'`

---
#### localhost_aliases
Array of aliases for localhost

- *Default*: `[ 'localhost', 'localhost4', 'localhost4.localdomain4' ]`

---
#### localhost6_name
Host name entry for ::1 (should be fqdn)

- *Default*: `'localhost6.localdomain6'`

---
#### localhost6_aliases
Array of aliases for localhost6

- *Default*: `[ 'localhost6', 'localhost6.localdomain6' ]`

---
#### fqdn_name
Host name entry for the hosts primary IP (see fqdn_ip).
This should probably be left as $::fqdn (default), as any aliases can be added
as `fqdn_host_aliases`. However, if you do change this parameter, you should
probably add `$::fqdn` to `fqdn_host_aliases`.

- *Default*: `$::fqdn`

---
#### fqdn_host_aliases
String or Array of aliases for FQDN

- *Default*: `$::hostname`

---
#### fqdn_ip
IP Address associated with entry used for FQDN.

- *Default*: `$::ipaddress`

---
#### purge_hosts
Boolean to optionally purge unmanaged entries from hosts

- *Default*: `false`

---
#### target
String for path to hosts file

- *Default*: `/etc/hosts`

---
#### host_entries
Hash of host entries

- *Default*: `undef`

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
