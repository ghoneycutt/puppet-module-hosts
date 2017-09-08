class { '::hosts':
  fqdn_ip => $facts['networking']['interfaces']['eth1']['ip'],
}
