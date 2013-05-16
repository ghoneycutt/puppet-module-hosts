# ## Class: hosts ##
#
# Manage /etc/hosts
#
# ### Parameters ###
#
# enable_ipv4_localhost
# ---------------------
# Boolean to enable ipv4 localhost entry
#
# - *Default*: true
#
# enable_ipv6_localhost
# ---------------------
# Boolean to enable ipv6 localhost entry
#
# - *Default*: true
#
# enable_fqdn_entry
# -----------------
# Boolean to enable entry for fqdn
#
# - *Default*: true
#
# fqdn_host_aliases
# -----------------
# String or Array of aliases for fqdn
#
# - *Default*: $::hostname
#
# localhost_aliases
# -----------------
# String or Array of aliases for localhost
#
# - *Default*: [ 'localhost', 'localhost4', 'localhost4.localdomain4' ]
#
# localhost6_aliases
# ------------------
# String or Array of aliases for localhost6
#
# - *Default*: [ 'localhost6', 'localhost6.localdomain6' ]
#
# purge_hosts
# -----------
# Boolean to optionally purge unmanaged entries from hosts
#
# - *Default*: false
#
# target
# ------
# String for path to hosts file
#
# - *Default*: /etc/hosts
#
class hosts (
  $enable_ipv4_localhost = 'true',
  $enable_ipv6_localhost = 'true',
  $enable_fqdn_entry     = 'true',
  $fqdn_host_aliases     = $::hostname,
  $localhost_aliases     = ['localhost',
                            'localhost4',
                            'localhost4.localdomain4'],
  $localhost6_aliases    = ['localhost6',
                            'localhost6.localdomain6'],
  $purge_hosts           = 'false',
  $target                = '/etc/hosts',
) {

  case $enable_ipv4_localhost {
    'true': {
      $localhost_ensure     = 'present'
      $localhost_ip         = '127.0.0.1'
      $my_localhost_aliases = $localhost_aliases
    }
    'false': {
      $localhost_ensure     = 'absent'
      $localhost_ip         = '127.0.0.1'
      $my_localhost_aliases = ''
    }
    default: {
      fail("hosts::enable_ipv4_localhost must be 'true' or 'false' and is ${enable_ipv4_localhost}")
    }
  }

  case $enable_ipv6_localhost {
    'true': {
      $localhost6_ensure     = 'present'
      $localhost6_ip         = '::1'
      $my_localhost6_aliases = $localhost6_aliases
    }
    'false': {
      $localhost6_ensure     = 'absent'
      $localhost6_ip         = '::1'
      $my_localhost6_aliases = undef
    }
    default: {
      fail("hosts::enable_ipv6_localhost must be 'true' or 'false' and is ${enable_ipv6_localhost}")
    }
  }

  case $enable_fqdn_entry {
    'true': {
      $fqdn_ensure          = 'present'
      $my_fqdn_host_aliases = $fqdn_host_aliases
      $fqdn_ip              = $::ipaddress
    }
    'false': {
      $fqdn_ensure       = 'absent'
      $my_fqdn_host_aliases = ''
      $fqdn_ip           = ''
    }
    default: {
      fail("hosts::enable_fqdn_entry must be 'true' or 'false' and is ${enable_fqdn_entry}")
    }
  }

  # On Debian based systems an entry for the fqdn with an alias of the hostname
  # and IP of 127.0.1.1 is expected.
  if $::osfamily == 'Debian' {
    $fqdn_ip_real = '127.0.1.1'
  } else {
    $fqdn_ip_real = $fqdn_ip
  }

  case $purge_hosts {
    'true','false': { }
    default: {
      fail("hosts::purge_hosts must be 'true' or 'false' and is ${purge_hosts}")
    }
  }

  Host {
    target => $target,
  }

  host { 'localhost':
    ensure => 'absent',
  }

  host { 'localhost.localdomain':
    ensure       => $localhost_ensure,
    host_aliases => $my_localhost_aliases,
    ip           => $localhost_ip,
  }

  host { 'localhost6.localdomain6':
    ensure       => $localhost6_ensure,
    host_aliases => $my_localhost6_aliases,
    ip           => $localhost6_ip,
  }

  @@host { $::fqdn:
    ensure       => $fqdn_ensure,
    host_aliases => $my_fqdn_host_aliases,
    ip           => $fqdn_ip_real,
  }

  # only collect the exported entry above
  Host <<| title == $::fqdn |>>

  resources { 'host':
    purge => $purge_hosts,
  }
}
