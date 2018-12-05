hosts module
============

Manage host entries.

Can ensure entries for localhost, localhost6, and $::fqdn, including aliases
and optionally purge unmanaged entries.

[![Build Status](https://api.travis-ci.org/ghoneycutt/puppet-module-hosts.png?branch=master)](https://travis-ci.org/ghoneycutt/puppet-module-hosts)

===

# Compatibility

This module has been tested to work on the following systems with the
latest Puppet v3, v3 with future parser, v4, v5 and v6.  See `.travis.yml`
for the exact matrix of supported Puppet and ruby versions.

It should work with any *nix based system that uses `/etc/hosts`.

===

# Parameters

enable_ipv4_localhost
---------------------
Boolean to enable ipv4 localhost entry

- *Default*: true

enable_ipv6_localhost
---------------------
Boolean to enable ipv6 localhost entry

- *Default*: true

enable_fqdn_entry
-----------------
Boolean to enable entry for fqdn

- *Default*: true

use_fqdn
--------
When enabled use the ${::fqdn} fact to determine the hosts entry for the local node.

- *Default*: true

fqdn_host_aliases
-----------------
String or Array of aliases for fqdn

- *Default*: $::hostname

localhost_aliases
-----------------
String or Array of aliases for localhost

- *Default*: [ 'localhost', 'localhost4', 'localhost4.localdomain4' ]

localhost6_aliases
------------------
String or Array of aliases for localhost6

- *Default*: [ 'localhost6', 'localhost6.localdomain6' ]

purge_hosts
-----------
Boolean to optionally purge unmanaged entries from hosts

- *Default*: false

target
------
String for path to hosts file

- *Default*: /etc/hosts

collect_all
-----------
Boolean to optionally collect all the exported Host resources

- *Default*: false

host_entries
------------
Hash of host entries

- *Default*: undef

===

# Hiera example of host_entries
<pre>
---
hosts::host_entries:
  'servicename.example.com':
    ip: '10.0.0.5'
    host_aliases:
      - 'servicename'
</pre>
