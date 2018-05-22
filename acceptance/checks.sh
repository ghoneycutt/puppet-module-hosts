#!/bin/bash -e

HOSTS_ORIG='/vagrant/acceptance/hosts.orig'

restore_hosts() {
  cp -f $HOSTS_ORIG /etc/hosts
}

echo -e "# Restoring /etc/hosts"
restore_hosts

echo -e "Applying examples/init.pp"
puppet apply -v /vagrant/examples/init.pp

# default entries after applying examples/init.pp
echo -e "\n\n##### With default values and fqdn_ip specified"
echo -e "## It should contain specified IP and name '192.168.99.10 test.example.com test'"
egrep "^192.168.99.10\s+test.example.com\s+test$" /etc/hosts
echo -e "## It should contain localhost/localhost4 '127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4'"
egrep "^127.0.0.1\s+localhost\s+localhost.localdomain\s+localhost4\s+localhost4.localdomain4$" /etc/hosts
echo -e "## It should contain localhost/localhost6 '::1 localhost6 localhost.localdomain localhost localhost6.localdomain6'"
egrep "^::1\s+localhost6\s+localhost.localdomain\s+localhost\s+localhost6.localdomain6$" /etc/hosts

# fqdn_ip
echo -e "\n\n##### With fqdn_ip specified as 192.168.9.9"
echo -e "# Restoring /etc/hosts"
restore_hosts
cat > /tmp/test.pp << EOF
class { '::hosts':
  fqdn_ip => '192.168.9.9',
}
EOF
puppet apply -v /tmp/test.pp
echo -e "## It should change IP for fqdn '192.168.9.9 test.example.com test'"
egrep "^192.168.9.9\s+test.example.com\s+test$" /etc/hosts

# fqdn_entry
echo -e "\n\n##### With fqdn_entry set to false"
echo -e "# Restoring /etc/hosts"
restore_hosts
cat > /tmp/test.pp << EOF
class { '::hosts':
  fqdn_ip => \$facts['networking']['interfaces']['eth1']['ip'],
  fqdn_entry => false,
}
EOF

puppet apply -v /tmp/test.pp
set +e
echo -e "## fqdn entry should not exist"
egrep "^192.168.99.10\s+test.example.com\s+test$" /etc/hosts
if [ $? -eq 0 ]; then
  echo "fqdn entry exists and should not"
  exit 1
fi
set -e

# host_entries
echo -e "\n\n##### With host_entries specified"
echo -e "# Restoring /etc/hosts"
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
echo -e "## It should include the two entries from the hash"
egrep "^10.10.10.10\s+foo.example.com\s+foo$" /etc/hosts
egrep "^10.20.20.20\s+bar.example.com\s+bar$" /etc/hosts

# purge_hosts
echo -e "\n\n##### With purge_hosts set to true"
echo -e "# Restoring /etc/hosts"
restore_hosts
echo -e "Adding entry '1.2.3.4 should_not_exist nope' to /etc/hosts"
echo '1.2.3.4 should_not_exist nope' >> /etc/hosts
cat > /tmp/test.pp << EOF
class { '::hosts':
  purge_hosts => true,
}
EOF
puppet apply -v /tmp/test.pp
echo -e "## Should remove host 'should_not_exist'"
set +e
egrep "1.2.3.4|should_not_exist" /etc/hosts
if [ $? -eq 0 ]; then
  echo "1.2.3.4 should_not_exist entry exists and should not"
  exit 1
fi
set -e

# multiple localhost entries
echo -e "\n\n##### With multiple host_entry resources having localhost as the name specified"
echo -e "# Restoring /etc/hosts"
restore_hosts
cat > /tmp/test.pp << EOF
class { '::hosts':
  purge_hosts => true,
  host_entries => {
    'localhost ipv4' => {
      ip => '127.0.0.1',
      hostname => 'localhost',
      host_aliases => ['localhost.localdomain','localhost4','localhost4.localdomain4'],
    },
    'localhost ipv6' => {
      ip => '::1',
      hostname => 'localhost',
      host_aliases => ['localhost.localdomain','localhost6','localhost6.localdomain6'],
    },
  },
}
EOF

puppet apply -v /tmp/test.pp
echo -e "## It should include the two entries from the hash"
egrep "^127.0.0.1\s+localhost\s+localhost.localdomain\s+localhost4\s+localhost4.localdomain4$" /etc/hosts
egrep "::1\s+localhost\s+localhost.localdomain\s+localhost6\s+localhost6.localdomain6$" /etc/hosts
echo -e "## It should include only two entries"
lines=$(wc -l /etc/hosts | awk '{print $1}')
if [ $lines != '6' ]; then
  echo "expecting 6 lines (2 entries, 1 for fqdn and 3 for comments) and found ${lines} lines"
  exit 1
fi

# Fix /etc/hosts
echo -e "\n\n##### Restoring /etc/hosts to original"
restore_hosts
cat /etc/hosts
