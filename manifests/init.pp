# == Class: hosts
#
# Manage /etc/hosts
#
class hosts (
  Boolean $enable_ipv4_localhost = true,
  Boolean $enable_ipv6_localhost = true,
  Boolean $enable_fqdn_entry = true,
  Variant[String, Array[String, 1]] $fqdn_host_aliases = $::hostname,
  String $localhost_name = 'localhost.localdomain',
  Array[String, 1] $localhost_aliases = ['localhost',
                                          'localhost4',
                                          'localhost4.localdomain4'],
  String $localhost6_name = 'localhost6.localdomain6',
  Array[String, 1] $localhost6_aliases = ['localhost6'],
  Boolean $purge_hosts = false,
  Optional[Stdlib::Absolutepath] $target = undef,
  Optional[Hash] $host_entries = undef,
  String $fqdn_name = $::fqdn,
  Stdlib::IP::Address $fqdn_ip = $::ipaddress,
) {

  # Set default hosts file $target in this scope
  Host {
    target => $target,
  }

  # IPv4 localhost
  if $enable_ipv4_localhost {
    host { $localhost_name:
      ensure       => present,
      ip           => '127.0.0.1',
      host_aliases => $localhost_aliases,
    }

    if $localhost_name != 'localhost' and $localhost6_name != 'localhost' {
      # The spec tests seem pretty adamant that we should remove this
      host { 'localhost':
        ensure => absent,
      }
    }
  }

  # IPv6 localhost
  if $enable_ipv6_localhost {
    host { $localhost6_name:
      ensure       => present,
      ip           => '::1',
      host_aliases => $localhost6_aliases,
    }
  }

  # FQDN
  if $enable_fqdn_entry {
    host { $fqdn_name:
      ensure       => present,
      host_aliases => $fqdn_host_aliases,
      ip           => $fqdn_ip,
    }
  }

  resources { 'host':
    purge => $purge_hosts,
  }

  if $host_entries != undef {
    $_host_entries = delete($host_entries,$::fqdn)
    $_host_entries.each |$k,$v| {
      host { $k:
        * => $v,
      }
    }
  }
}
