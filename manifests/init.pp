# @summary hosts class
#
# Manage /etc/hosts
#
# @param enable_ipv4_localhost Boolean to enable ipv4 localhost entry.
# @param enable_ipv6_localhost Boolean to enable ipv6 localhost entry.
# @param enable_fqdn_entry Boolean to enable entry for fqdn.
# @param fqdn_host_aliases String or Array of aliases for fqdn.
# @param localhost_aliases Array of aliases for localhost.
# @param localhost6_aliases Array of aliases for localhost6.
# @param purge_hosts Boolean to optionally purge unmanaged entries from hosts.
# @param target String for path to hosts file.
# @param host_entries Hash of host entries.
# @param fqdn_ip IP Address associated with entry used for FQDN.
#
class hosts (
  Boolean $enable_ipv4_localhost = true,
  Boolean $enable_ipv6_localhost = true,
  Boolean $enable_fqdn_entry = true,
  Stdlib::IP::Address $fqdn_ip = $::ipaddress,
  Variant[String, Array[String, 1]] $fqdn_host_aliases = $::hostname,
  Array[String, 1] $localhost_aliases = [
    'localhost.localdomain',
    'localhost4',
    'localhost4.localdomain4',
  ],
  Array[String, 1] $localhost6_aliases = [
    'localhost.localdomain',
    'localhost',
    'localhost6.localdomain6',
  ],
  Boolean $purge_hosts = false,
  Stdlib::Absolutepath $target = '/etc/hosts',
  Variant[Undef, Hash] $host_entries = undef,
) {

  if $enable_ipv4_localhost == true {
    $localhost_ensure     = 'present'
    $localhost_ip         = '127.0.0.1'
    $_localhost_aliases = $localhost_aliases
  } else {
    $localhost_ensure     = 'absent'
    $localhost_ip         = '127.0.0.1'
    $_localhost_aliases = undef
  }

  if $enable_ipv6_localhost == true {
    $localhost6_ensure     = 'present'
    $localhost6_ip         = '::1'
    $_localhost6_aliases = $localhost6_aliases
  } else {
    $localhost6_ensure     = 'absent'
    $localhost6_ip         = '::1'
    $_localhost6_aliases = undef
  }

  if $enable_fqdn_entry == true {
    $fqdn_ensure          = 'present'
    $_fqdn_host_aliases = $fqdn_host_aliases
  } else {
    $fqdn_ensure          = 'absent'
    $_fqdn_host_aliases = undef
  }

  $host_defaults = {
    'target' => $target,
  }

  host { 'localhost':
    ensure       => $localhost_ensure,
    ip           => $localhost_ip,
    host_aliases => $_localhost_aliases,
    *            => $host_defaults,
  }

  host { 'localhost6':
    ensure       => $localhost6_ensure,
    ip           => $localhost6_ip,
    host_aliases => $_localhost6_aliases,
    *            => $host_defaults,
  }

  host { $::fqdn:
    ensure       => $fqdn_ensure,
    host_aliases => $_fqdn_host_aliases,
    ip           => $fqdn_ip,
    *            => $host_defaults,
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
