# == Class: hosts
#
# Manage /etc/hosts
#
class hosts (
  Boolean $enable_ipv4_localhost = true,
  Boolean $enable_ipv6_localhost = true,
  Boolean $enable_fqdn_entry = true,
  Variant[String, Array[String, 1]] $fqdn_host_aliases = $::hostname,
  Array[String, 1] $localhost_aliases = ['localhost.localdomain',
                                          'localhost4',
                                          'localhost4.localdomain4'],
  Array[String, 1] $localhost6_aliases = ['localhost6.localdomain6'],
  Boolean $purge_hosts = false,
  Stdlib::Absolutepath $target = '/etc/hosts',
  Variant[Undef, Hash] $host_entries = undef,
  IP::Address $fqdn_ip = $::ipaddress,
) {

  if $enable_ipv4_localhost == true {
    $localhost_ensure     = 'present'
    $localhost_ip         = '127.0.0.1'
    $my_localhost_aliases = $localhost_aliases
  } else {
    $localhost_ensure     = 'absent'
    $localhost_ip         = '127.0.0.1'
    $my_localhost_aliases = undef
  }

  if $enable_ipv6_localhost == true {
    $localhost6_ensure     = 'present'
    $localhost6_ip         = '::1'
    $my_localhost6_aliases = $localhost6_aliases
  } else {
    $localhost6_ensure     = 'absent'
    $localhost6_ip         = '::1'
    $my_localhost6_aliases = undef
  }

  if $enable_fqdn_entry == true {
    $fqdn_ensure          = 'present'
    $my_fqdn_host_aliases = $fqdn_host_aliases
  } else {
    $fqdn_ensure          = 'absent'
    $my_fqdn_host_aliases = []
  }

  $host_defaults = {
    'target' => $target,
  }


#  host { 'localhost':
#    ensure => 'absent',
#    *      => $host_defaults,
#  }

#  host { 'localhost':
#    ensure       => $localhost_ensure,
#    host_aliases => $my_localhost_aliases,
#    ip           => $localhost_ip,
#    *            => $host_defaults,
#  }
#
#  host { 'localhost6':
#    ensure       => $localhost6_ensure,
#    host_aliases => $my_localhost6_aliases,
#    ip           => $localhost6_ip,
#    *            => $host_defaults,
#  }

  host { $::fqdn:
    ensure       => $fqdn_ensure,
    host_aliases => $my_fqdn_host_aliases,
    ip           => $fqdn_ip,
    *            => $host_defaults,
  }

#  resources { 'host':
#    purge => $purge_hosts,
#  }

  if $host_entries != undef {
    $_host_entries = delete($host_entries,$::fqdn)

    $_host_entries.each |$k,$v| {
      host { $k:
        * => $v,
      }
    }
  }
}
