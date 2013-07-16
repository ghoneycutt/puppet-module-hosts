# hosts module #

Manage host entries.

Can ensure entries for localhost, localhost6, and $::fqdn, including aliases
and optionally purge unmanaged entries.

# Parameters #

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
Boolean to optionally collect all the exported Host resources from puppetdb

- *Default*: false 
