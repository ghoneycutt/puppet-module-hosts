# == Class: hosts
#
# Manage /etc/hosts
#
class hosts (
  $stored_config         = true,
  $collect_all           = false,
  $enable_ipv4_localhost = true,
  $enable_ipv6_localhost = true,
  $enable_fqdn_entry     = true,
  $use_fqdn              = true,
  $fqdn_host_aliases     = $::hostname,
  $localhost_aliases     = ['localhost',
                            'localhost4',
                            'localhost4.localdomain4'],
  $localhost6_aliases    = ['localhost6',
                            'localhost6.localdomain6'],
  $purge_hosts           = false,
  $target                = '/etc/hosts',
  $host_entries          = undef,
) {


  # validate type and convert string to boolean if necessary
  if is_string($collect_all) {
    $collect_all_real = str2bool($collect_all)
  } else {
    $collect_all_real = $collect_all
  }

  # validate type and convert string to boolean if necessary
  if is_string($stored_config) {
    $stored_config_real = str2bool($stored_config)
  } else {
    $stored_config_real = $stored_config
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_ipv4_localhost) {
    $ipv4_localhost_enabled = str2bool($enable_ipv4_localhost)
  } else {
    $ipv4_localhost_enabled = $enable_ipv4_localhost
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_ipv6_localhost) {
    $ipv6_localhost_enabled = str2bool($enable_ipv6_localhost)
  } else {
    $ipv6_localhost_enabled = $enable_ipv6_localhost
  }

  # validate type and convert string to boolean if necessary
  if is_string($enable_fqdn_entry) {
    $fqdn_entry_enabled = str2bool($enable_fqdn_entry)
  } else {
    $fqdn_entry_enabled = $enable_fqdn_entry
  }

  # validate type and convert string to boolean if necessary
  if is_string($use_fqdn) {
    $use_fqdn_real = str2bool($use_fqdn)
  } else {
    $use_fqdn_real = $use_fqdn
  }

  # validate type and convert string to boolean if necessary
  if is_string($purge_hosts) {
    $purge_hosts_enabled = str2bool($purge_hosts)
  } else {
    $purge_hosts_enabled = $purge_hosts
  }

  if $ipv4_localhost_enabled == true {
    $localhost_ensure     = 'present'
    $localhost_ip         = '127.0.0.1'
    $my_localhost_aliases = $localhost_aliases
  } else {
    $localhost_ensure     = 'absent'
    $localhost_ip         = '127.0.0.1'
    $my_localhost_aliases = undef
  }

  if $ipv6_localhost_enabled == true {
    $localhost6_ensure     = 'present'
    $localhost6_ip         = '::1'
    $my_localhost6_aliases = $localhost6_aliases
  } else {
    $localhost6_ensure     = 'absent'
    $localhost6_ip         = '::1'
    $my_localhost6_aliases = undef
  }

  if !is_string($my_localhost_aliases) and !is_array($my_localhost_aliases) {
    fail('hosts::localhost_aliases must be a string or an array.')
  }

  if !is_string($my_localhost6_aliases) and !is_array($my_localhost6_aliases) {
    fail('hosts::localhost6_aliases must be a string or an array.')
  }

  if $fqdn_entry_enabled == true {
    $fqdn_ensure          = 'present'
    $my_fqdn_host_aliases = $fqdn_host_aliases
    $fqdn_ip              = $::ipaddress
  } else {
    $fqdn_ensure          = 'absent'
    $my_fqdn_host_aliases = []
    $fqdn_ip              = $::ipaddress
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

  if $use_fqdn_real == true {
    if $stored_config_real == true {
      @@host { $::fqdn:
        ensure       => $fqdn_ensure,
        host_aliases => $my_fqdn_host_aliases,
        ip           => $fqdn_ip,
      }
      case $collect_all_real {
        # collect all the exported Host resources
        true:  {
          Host <<| |>>
        }
        # only collect the exported entry above
        default: {
          Host <<| title == $::fqdn |>>
        }
      }
    } else {
      host { $::fqdn:
        ensure       => $fqdn_ensure,
        host_aliases => $my_fqdn_host_aliases,
        ip           => $fqdn_ip,
      }
    }
  }

  resources { 'host':
    purge => $purge_hosts,
  }

  if $host_entries != undef {
    $host_entries_real = delete($host_entries,$::fqdn)
    validate_hash($host_entries_real)
    create_resources(host,$host_entries_real)
  }
}
