# == Class: hosts
#
# Manage /etc/hosts
#
class hosts (
  $collect_all           = false,
  $enable_ipv4_localhost = true,
  $enable_ipv6_localhost = true,
  $enable_fqdn_entry     = true,
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
  $collect_all_type = type($collect_all)
  if $collect_all_type == 'string' {
    $collect_all_real = str2bool($collect_all)
  } else {
    $collect_all_real = $collect_all
  }

  # validate type and convert string to boolean if necessary
  $enable_ipv4_localhost_type = type($enable_ipv4_localhost)
  if $enable_ipv4_localhost_type == 'string' {
    $ipv4_localhost_enabled = str2bool($enable_ipv4_localhost)
  } else {
    $ipv4_localhost_enabled = $enable_ipv4_localhost
  }

  # validate type and convert string to boolean if necessary
  $enable_ipv6_localhost_type = type($enable_ipv6_localhost)
  if $enable_ipv6_localhost_type == 'string' {
    $ipv6_localhost_enabled = str2bool($enable_ipv6_localhost)
  } else {
    $ipv6_localhost_enabled = $enable_ipv6_localhost
  }

  # validate type and convert string to boolean if necessary
  $enable_fqdn_entry_type = type($enable_fqdn_entry)
  if $enable_fqdn_entry_type == 'string' {
    $fqdn_entry_enabled = str2bool($enable_fqdn_entry)
  } else {
    $fqdn_entry_enabled = $enable_fqdn_entry
  }

  # validate type and convert string to boolean if necessary
  $purge_hosts_type = type($purge_hosts)
  if $purge_hosts_type == 'string' {
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
    $my_localhost_aliases = ''
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

  $my_localhost_aliases_type = type($my_localhost_aliases)
  if $my_localhost_aliases_type != 'string' and $my_localhost_aliases_type != 'array' {
    fail("hosts::localhost_aliases must be a string or an array. Detected type is <${my_localhost_aliases_type}>.")
  }

  $my_localhost6_aliases_type = type($my_localhost6_aliases)
  if $my_localhost6_aliases_type != 'string' and $my_localhost6_aliases_type != 'array' {
    fail("hosts::localhost6_aliases must be a string or an array. Detected type is <${my_localhost6_aliases_type}>.")
  }

  if $fqdn_entry_enabled == true {
    $fqdn_ensure          = 'present'
    $my_fqdn_host_aliases = $fqdn_host_aliases
    $fqdn_ip              = $::ipaddress
  } else {
    $fqdn_ensure          = 'absent'
    $my_fqdn_host_aliases = ''
    $fqdn_ip              = ''
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

  resources { 'host':
    purge => $purge_hosts,
  }

  if $host_entries != undef {
    validate_hash($host_entries)
    create_resources(host,$host_entries)
  }
}
