# @summary hosts class
#
# Manage /etc/hosts
#
# @param fqdn_entry Boolean to enable entry for fqdn.
# @param fqdn_ip IP Address associated with entry used for FQDN.
# @param fqdn_host_aliases String or Array of aliases for fqdn.
# @param purge_hosts Boolean to optionally purge unmanaged entries from hosts.
# @param host_entries Hash of host entries.
# @param target Optional absolute path to hosts file. By default this is
# `undef` and the provider will choose the correct path for the system.
#
class hosts (
  Boolean $fqdn_entry = true,
  Stdlib::IP::Address $fqdn_ip = $::ipaddress,
  Variant[String, Array[String, 1]] $fqdn_host_aliases = $::hostname,
  Boolean $purge_hosts = false,
  Optional[Hash] $host_entries = undef,
  Optional[Stdlib::Absolutepath] $target = undef,
) {

  if $fqdn_entry == true {
    $fqdn_ensure          = 'present'
    $_fqdn_host_aliases = $fqdn_host_aliases
  } else {
    $fqdn_ensure          = 'absent'
    $_fqdn_host_aliases = undef
  }

  $host_defaults = {
    'target' => $target,
  }

  host_entry { $::fqdn:
    ensure       => $fqdn_ensure,
    host_aliases => $_fqdn_host_aliases,
    ip           => $fqdn_ip,
    *            => $host_defaults,
  }

  resources { 'host_entry':
    purge => $purge_hosts,
  }

  if $host_entries != undef {
    if $target == undef {
      $host_entries_merged = $host_entries
    } else {
      $host_entries_merged = $host_defaults + $host_entries
    }
    $_host_entries = delete($host_entries_merged, $::fqdn)

    $_host_entries.each |$host, $params| {
      host_entry { $host:
        * => $params,
      }
    }
  }
}
