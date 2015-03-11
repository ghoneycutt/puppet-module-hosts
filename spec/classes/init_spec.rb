require 'spec_helper'
describe 'hosts' do

  it { should compile.with_all_deps }

  context 'with default parameter settings' do
    let(:facts) {
      { :hostname  => 'monkey',
        :ipaddress => '10.1.2.3',
        :fqdn      => 'monkey.example.com',
      }
    }

    it {
      should contain_host('localhost').with({
        'ensure' => 'absent',
        'target' => '/etc/hosts',
      })
    }

    it {
      should contain_host('localhost.localdomain').with({
        'ensure'       => 'present',
        'host_aliases' => ['localhost', 'localhost4', 'localhost4.localdomain4'],
        'ip'           => '127.0.0.1',
        'target'       => '/etc/hosts',
      })
    }

    it {
      should contain_host('localhost6.localdomain6').with({
        'ensure'       => 'present',
        'host_aliases' => ['localhost6', 'localhost6.localdomain6'],
        'ip'           => '::1',
        'target'       => '/etc/hosts',
      })
    }

#    # GH: rspec-puppet does not yet support checking for exported resources
#    it {
#      should contain_host('monkey.example.com').with({
#        'ensure'       => 'present',
#        'host_aliases' => ['monkey'],
#        'ip'           => '10.1.2.3',
#      })
#    }

    it { should contain_resources('host').with({'purge' => 'false'}) }
  end

  describe 'with \'enable_ipv4_localhost\' parameter set to' do
    [false, 'false'].each do |enable_ipv4_localhost_value|
      context "#{enable_ipv4_localhost_value}" do
        let(:params) { { :enable_ipv4_localhost => enable_ipv4_localhost_value } }
        let(:facts) {
          { :hostname  => 'monkey',
            :ipaddress => '10.1.2.3',
            :fqdn      => 'monkey.example.com',
          }
        }

        it { should compile }

        it {
          should contain_host('localhost').with({
            'ensure' => 'absent',
            'target' => '/etc/hosts',
          })
        }

        it {
          should contain_host('localhost.localdomain').with({
            'ensure'       => 'absent',
            'host_aliases' => '',
            'ip'           => '127.0.0.1',
            'target'       => '/etc/hosts',
          })
        }

        it {
          should contain_host('localhost6.localdomain6').with({
            'ensure'       => 'present',
            'host_aliases' => ['localhost6', 'localhost6.localdomain6'],
            'ip'           => '::1',
            'target'       => '/etc/hosts',
          })
        }

        it { should contain_resources('host').with({'purge' => 'false'}) }
      end
    end
  end

  describe 'with \'enable_ipv6_localhost\' parameter set to' do
    [false, 'false'].each do |enable_ipv6_localhost_value|
      context "#{enable_ipv6_localhost_value}" do
        let(:params) { { :enable_ipv6_localhost => enable_ipv6_localhost_value } }
        let(:facts) {
          { :hostname  => 'monkey',
            :ipaddress => '10.1.2.3',
            :fqdn      => 'monkey.example.com',
          }
        }

        it {
          should contain_host('localhost').with({
            'ensure' => 'absent',
            'target' => '/etc/hosts',
          })
        }

        it {
          should contain_host('localhost.localdomain').with({
            'ensure'       => 'present',
            'host_aliases' => ['localhost', 'localhost4', 'localhost4.localdomain4'],
            'ip'           => '127.0.0.1',
            'target'       => '/etc/hosts',
          })
        }

        it {
          should contain_host('localhost6.localdomain6').with({
            'ensure'       => 'absent',
            'host_aliases' => '',
            'ip'           => '::1',
            'target'       => '/etc/hosts',
          })
        }

        it { should contain_resources('host').with({'purge' => 'false'}) }
      end
    end
  end

  describe 'with \'enable_fqdn_entry\' parameter set to' do
    [false, 'false'].each do |enable_fqdn_entry_value|
      context "#{enable_fqdn_entry_value}" do
        let(:params) { { :enable_fqdn_entry => enable_fqdn_entry_value } }
        let(:facts) {
          { :hostname  => 'monkey',
            :ipaddress => '10.1.2.3',
            :fqdn      => 'monkey.example.com',
          }
        }

        it {
          should contain_host('localhost').with({
            'ensure' => 'absent',
            'target' => '/etc/hosts',
          })
        }

        it {
          should contain_host('localhost.localdomain').with({
            'ensure'       => 'present',
            'host_aliases' => ['localhost', 'localhost4', 'localhost4.localdomain4'],
            'ip'           => '127.0.0.1',
            'target'       => '/etc/hosts',
          })
        }

        it {
          should contain_host('localhost6.localdomain6').with({
            'ensure'       => 'present',
            'host_aliases' => ['localhost6', 'localhost6.localdomain6'],
            'ip'           => '::1',
            'target'       => '/etc/hosts',
          })
        }

        it { should_not contain_host('monkey.example.com') }

        it { should contain_resources('host').with({'purge' => 'false'}) }
      end
    end
  end

  describe 'with \'use_fqdn\' parameter set to' do
    [false, 'false'].each do |use_fqdn_value|
      context "#{use_fqdn_value}" do
        let(:params) { { :use_fqdn => use_fqdn_value } }
        let(:facts) {
          { :hostname  => 'monkey',
            :ipaddress => '10.1.2.3',
            :fqdn      => 'monkey.example.com',
          }
        }

        it {
          should contain_host('localhost').with({
            'ensure' => 'absent',
            'target' => '/etc/hosts',
          })
        }

        it {
          should contain_host('localhost.localdomain').with({
            'ensure'       => 'present',
            'host_aliases' => ['localhost', 'localhost4', 'localhost4.localdomain4'],
            'ip'           => '127.0.0.1',
            'target'       => '/etc/hosts',
          })
        }

        it {
          should contain_host('localhost6.localdomain6').with({
            'ensure'       => 'present',
            'host_aliases' => ['localhost6', 'localhost6.localdomain6'],
            'ip'           => '::1',
            'target'       => '/etc/hosts',
          })
        }

        it { should_not contain_host('monkey.example.com') }

        it { should contain_resources('host').with({'purge' => 'false'}) }
      end
    end
  end

  describe 'with \'use_fqdn\' parameter set to' do
    [true,'true'].each do |use_fqdn_value|
      context "#{use_fqdn_value}" do
        let(:params) { { :use_fqdn => use_fqdn_value } }
        let(:facts) {
          { :hostname  => 'monkey',
            :ipaddress => '10.1.2.3',
            :fqdn      => 'monkey.example.com',
          }
        }

        it {
          should contain_host('localhost').with({
            'ensure' => 'absent',
            'target' => '/etc/hosts',
          })
        }

        it {
          should contain_host('localhost.localdomain').with({
            'ensure'       => 'present',
            'host_aliases' => ['localhost', 'localhost4', 'localhost4.localdomain4'],
            'ip'           => '127.0.0.1',
            'target'       => '/etc/hosts',
          })
        }

        it {
          should contain_host('localhost6.localdomain6').with({
            'ensure'       => 'present',
            'host_aliases' => ['localhost6', 'localhost6.localdomain6'],
            'ip'           => '::1',
            'target'       => '/etc/hosts',
          })
        }

#        # GH: rspec-puppet does not yet support checking for exported resources
#        it {
#          should contain_host('monkey.example.com').with({
#            'ensure'       => 'present',
#            'host_aliases' => ['monkey'],
#            'ip'           => '10.1.2.3',
#          })
#        }

        it { should contain_resources('host').with({'purge' => 'false'}) }
      end
    end
  end

  describe 'with \'localhost_aliases\' parameter set to' do
    context 'single value' do
      let(:params) { { :localhost_aliases => 'home' } }
      let(:facts) {
        { :hostname  => 'monkey',
          :ipaddress => '10.1.2.3',
          :fqdn      => 'monkey.example.com',
        }
      }

      it {
        should contain_host('localhost').with({
          'ensure' => 'absent',
          'target' => '/etc/hosts',
        })
      }

      it {
        should contain_host('localhost.localdomain').with({
          'ensure'       => 'present',
          'host_aliases' => 'home',
          'ip'           => '127.0.0.1',
          'target'       => '/etc/hosts',
        })
      }

      it {
        should contain_host('localhost6.localdomain6').with({
          'ensure'       => 'present',
          'host_aliases' => ['localhost6', 'localhost6.localdomain6'],
          'ip'           => '::1',
          'target'       => '/etc/hosts',
        })
      }

      it { should contain_resources('host').with({'purge' => 'false'}) }
    end

    context 'an array' do
      let(:params) { { :localhost_aliases => ['home','home.mydomain'] } }
      let(:facts) {
        { :hostname  => 'monkey',
          :ipaddress => '10.1.2.3',
          :fqdn      => 'monkey.example.com',
        }
      }

      it {
        should contain_host('localhost').with({
          'ensure' => 'absent',
          'target' => '/etc/hosts',
        })
      }

      it {
        should contain_host('localhost.localdomain').with({
          'ensure'       => 'present',
          'host_aliases' => ['home','home.mydomain'],
          'ip'           => '127.0.0.1',
          'target'       => '/etc/hosts',
        })
      }

      it {
        should contain_host('localhost6.localdomain6').with({
          'ensure'       => 'present',
          'host_aliases' => ['localhost6', 'localhost6.localdomain6'],
          'ip'           => '::1',
          'target'       => '/etc/hosts',
        })
      }

      it { should contain_resources('host').with({'purge' => 'false'}) }
    end

    context 'an invalid type (not array or string)' do
      let(:params) { { :localhost_aliases => true } }
      let(:facts) {
        { :hostname  => 'monkey',
          :ipaddress => '10.1.2.3',
          :fqdn      => 'monkey.example.com',
        }
      }

      it 'should fail' do
        expect {
          should contain_class('hosts')
        }.to raise_error(Puppet::Error,/hosts::localhost_aliases must be a string or an array./)
      end
    end
  end

  describe 'with \'localhost6_aliases\' parameter set to' do
    context 'single value' do
      let(:params) { { :localhost6_aliases => 'home6' } }
      let(:facts) {
        { :hostname  => 'monkey',
          :ipaddress => '10.1.2.3',
          :fqdn      => 'monkey.example.com',
        }
      }

      it {
        should contain_host('localhost').with({
          'ensure' => 'absent',
          'target' => '/etc/hosts',
        })
      }

      it {
        should contain_host('localhost.localdomain').with({
          'ensure'       => 'present',
          'host_aliases' => ['localhost', 'localhost4', 'localhost4.localdomain4'],
          'ip'           => '127.0.0.1',
          'target'       => '/etc/hosts',
        })
      }

      it {
        should contain_host('localhost6.localdomain6').with({
          'ensure'       => 'present',
          'host_aliases' => 'home6',
          'ip'           => '::1',
          'target'       => '/etc/hosts',
        })
      }

      it { should contain_resources('host').with({'purge' => 'false'}) }
    end

    context 'an array' do
      let(:params) { { :localhost6_aliases => ['home6','home6.mydomain'] } }
      let(:facts) {
        { :hostname  => 'monkey',
          :ipaddress => '10.1.2.3',
          :fqdn      => 'monkey.example.com',
        }
      }

      it {
        should contain_host('localhost').with({
          'ensure' => 'absent',
          'target' => '/etc/hosts',
        })
      }

      it {
        should contain_host('localhost.localdomain').with({
          'ensure'       => 'present',
          'host_aliases' => ['localhost', 'localhost4', 'localhost4.localdomain4'],
          'ip'           => '127.0.0.1',
          'target'       => '/etc/hosts',
        })
      }

      it {
        should contain_host('localhost6.localdomain6').with({
          'ensure'       => 'present',
          'host_aliases' => ['home6','home6.mydomain'],
          'ip'           => '::1',
          'target'       => '/etc/hosts',
        })
      }

      it { should contain_resources('host').with({'purge' => 'false'}) }
    end

    context 'an invalid type (not array or string)' do
      let(:params) { { :localhost6_aliases => true } }
      let(:facts) {
        { :hostname  => 'monkey',
          :ipaddress => '10.1.2.3',
          :fqdn      => 'monkey.example.com',
        }
      }

      it 'should fail' do
        expect {
          should contain_class('hosts')
        }.to raise_error(Puppet::Error,/hosts::localhost6_aliases must be a string or an array./)
      end
    end
  end

  describe 'with \'purge_hosts\' parameter set to' do
    [true, 'true'].each do |purge_hosts_value|
      context "#{purge_hosts_value}" do
        let(:params) { { :purge_hosts => purge_hosts_value } }
        let(:facts) {
          { :hostname  => 'monkey',
            :ipaddress => '10.1.2.3',
            :fqdn      => 'monkey.example.com',
          }
        }

        it {
          should contain_host('localhost').with({
            'ensure' => 'absent',
            'target' => '/etc/hosts',
          })
        }

        it {
          should contain_host('localhost.localdomain').with({
            'ensure'       => 'present',
            'host_aliases' => ['localhost', 'localhost4', 'localhost4.localdomain4'],
            'ip'           => '127.0.0.1',
            'target'       => '/etc/hosts',
          })
        }

        it {
          should contain_host('localhost6.localdomain6').with({
            'ensure'       => 'present',
            'host_aliases' => ['localhost6', 'localhost6.localdomain6'],
            'ip'           => '::1',
            'target'       => '/etc/hosts',
          })
        }

        it { should contain_resources('host').with({'purge' => 'true'}) }
      end
    end
  end

  context 'with \'target\' parameter specified' do
    let(:params) { { :target => '/usr/local/etc/hosts' } }
    let(:facts) {
      { :hostname  => 'monkey',
        :ipaddress => '10.1.2.3',
        :fqdn      => 'monkey.example.com',
      }
    }

    it {
      should contain_host('localhost').with({
        'ensure' => 'absent',
        'target' => '/usr/local/etc/hosts',
      })
    }

    it {
      should contain_host('localhost.localdomain').with({
        'ensure'       => 'present',
        'host_aliases' => ['localhost', 'localhost4', 'localhost4.localdomain4'],
        'ip'           => '127.0.0.1',
        'target'       => '/usr/local/etc/hosts',
      })
    }

    it {
      should contain_host('localhost6.localdomain6').with({
        'ensure'       => 'present',
        'host_aliases' => ['localhost6', 'localhost6.localdomain6'],
        'ip'           => '::1',
        'target'       => '/usr/local/etc/hosts',
      })
    }

    it { should contain_resources('host').with({'purge' => 'false'}) }
  end

  context 'with hosts defined' do
   let(:params) { { :host_entries => {
      'myhost.example.com' => {
        'ip' => '10.0.0.5',
        'host_aliases' => ['myhost'],
      },
      'myhost2.example.com' => {
        'ip' => '10.0.0.6',
        'host_aliases' => ['myhost2','loghost'],
      },
    } } }

    it {
      should contain_host('myhost.example.com').with({
        'ip' => '10.0.0.5',
        'host_aliases' => ['myhost'],
      })
    }

    it {
      should contain_host('myhost2.example.com').with({
        'ip' => '10.0.0.6',
        'host_aliases' => ['myhost2','loghost'],
      })
    }
  end

  context 'with host_entries containing post for fqdn' do
    let(:facts) { { :fqdn => 'myhost.example.com',
                    :ip   => '10.0.0.5',} }
    let(:params) {
      { :host_entries => {
          'myhost.example.com' => {
            'ip'           => '10.0.0.5',
            'host_aliases' => 'myhost',
          },
          'anotherhost.example.com' => {
            'ip'           => '10.0.0.6',
            'host_aliases' => 'anotherhost',
          },
        } } }

    it {
      should_not contain_host('myhost.example.com').with({
        'ip' => '10.0.0.5',
        'host_aliases' => ['myhost',],
      })
    }

    it {
      should contain_host('anotherhost.example.com').with({
        'ip' => '10.0.0.6',
        'host_aliases' => ['anotherhost',],
      })
    }
  end

  context 'with host specified as not of type hash' do
    let(:params) { { :keys => [ 'not', 'a', 'hash' ] } }

    it 'should fail' do
      expect {
        should contain_class('hosts')
      }.to raise_error(Puppet::Error)
    end
  end
end
