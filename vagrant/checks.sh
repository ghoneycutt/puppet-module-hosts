#!/bin/bash -e

HOSTS_ORIG='/vagrant/vagrant/hosts.orig'

restore_hosts() {
  cp -f $HOSTS_ORIG /etc/hosts
}

# default entries after applying examples/init.pp
egrep "^192.168.99.10\s+test.example.com\s+test" /etc/hosts
egrep "^127.0.0.1\s+localhost\s+localhost.localdomain\s+localhost4\s+localhost4.localdomain4" /etc/hosts
egrep "^::1\s+localhost\s+localhost.localdomain\s+localhost6\s+localhost6.localdomain6" /etc/hosts

# fqdn_ip
echo -e "\n\n##### With fqdn_ip specified as 192.168.9.9"
restore_hosts
cat > /tmp/test.pp << EOF
class { '::hosts':
  fqdn_ip => '192.168.9.9',
}
EOF
puppet apply -v /tmp/test.pp
egrep "^192.168.9.9\s+test.example.com\s+test" /etc/hosts

# enable_fqdn_entry
echo -e "\n\n##### With enable_fqdn_entry set to false"
restore_hosts
cat > /tmp/test.pp << EOF
class { '::hosts':
  fqdn_ip => \$facts['networking']['interfaces']['eth1']['ip'],
  enable_fqdn_entry => false,
}
EOF

puppet apply -v /tmp/test.pp
set +e
egrep "^192.168.99.10\s+test.example.com\s+test" /etc/hosts
if [ $? -eq 0 ]; then
  echo "fqdn entry exists and should not"
  exit 1
fi
set -e

# host_entries
echo -e "\n\n##### With host_entries specified"
restore_hosts
cat > /tmp/test.pp << EOF
class { '::hosts':
  fqdn_ip => \$facts['networking']['interfaces']['eth1']['ip'],
  host_entries => {
    'foo.example.com' => {
      ip => '10.10.10.10',
      host_aliases => 'foo',
    },
    'bar.example.com' => {
      ip => '10.20.20.20',
      host_aliases => 'bar',
    },
  },
}
EOF

puppet apply -v /tmp/test.pp
egrep "^10.10.10.10\s+foo.example.com\s+foo" /etc/hosts
egrep "^10.20.20.20\s+bar.example.com\s+bar" /etc/hosts

# Fix /etc/hosts
echo -e "\n\n##### Restoring /etc/hosts to original"
restore_hosts
cat /etc/hosts
