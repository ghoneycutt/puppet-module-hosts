#!/bin/bash

# using this instead of "rpm -Uvh" to resolve dependencies
function rpm_install() {
    package=$(echo $1 | awk -F "/" '{print $NF}')
    wget --quiet $1
    yum install -y ./$package
    rm -f $package
}

release=$(awk -F \: '{print $5}' /etc/system-release-cpe)

rpm --import http://yum.puppetlabs.com/RPM-GPG-KEY-puppet

yum install -y wget

# install and configure puppet
rpm -qa | grep -q puppet
if [ $? -ne 0 ]
then

    rpm_install https://yum.puppetlabs.com/puppetlabs-release-pc1-el-${release}.noarch.rpm
    yum -y install puppet-agent
    ln -s /opt/puppetlabs/puppet/bin/puppet /usr/bin/puppet

    cat > /etc/puppetlabs/puppet/hiera.yaml <<EOF
---
version: 5
hierarchy:
  - name: Common
    path: common.yaml
defaults:
  data_hash: yaml_data
  datadir: /etc/puppetlabs/code/environments/production/hieradata
EOF

fi

# use local hosts module
puppet resource file /etc/puppetlabs/code/environments/production/modules/hosts ensure=link target=/vagrant

# setup module dependencies
puppet module install puppetlabs/stdlib --version 4.25.0
