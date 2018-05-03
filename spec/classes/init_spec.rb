require 'spec_helper'
describe 'hosts' do

  it { should compile.with_all_deps }

  describe 'with default parameter settings' do
    it {
      should contain_host('monkey.example.com').with({
        'ensure'       => 'present',
        'ip'           => '10.1.2.3',
        'host_aliases' => 'monkey',
        'target'       => nil,
      })
    }

    it { should contain_resources('host').with({'purge' => false}) }

  end

  describe 'with fqdn_entry' do
    context 'set to false' do
      let(:params) { { :fqdn_entry => false } }

      it {
        should contain_host('monkey.example.com').with({
          'ensure'       => 'absent',
          'ip'           => '10.1.2.3',
          'host_aliases' => nil,
        })
      }
    end

    context 'set to true' do
      context 'and fqdn_ip set' do
        let(:params) do
          {
            :fqdn_entry => true,
            :fqdn_ip           => '10.11.22.33',
          }
        end

        it { should contain_host('monkey.example.com').with({'ip' => '10.11.22.33'}) }
      end

      describe 'and fqdn_host_aliases' do
        context 'set to a string' do
          let(:params) do
            {
              :fqdn_entry => true,
              :fqdn_host_aliases => 'monkeyman',
            }
          end

          it {
            should contain_host('monkey.example.com').with({
              'host_aliases' => 'monkeyman',
            })
          }
        end

        context 'set to an array of strings' do
          let(:params) do
            {
              :fqdn_entry => true,
              :fqdn_host_aliases => ['monkey', 'monkeyman'],
            }
          end

          it {
            should contain_host('monkey.example.com').with({
              'host_aliases' => ['monkey', 'monkeyman'],
            })
          }
        end
      end
    end
  end

  describe 'with purge_hosts set to true' do
    let(:params) { { :purge_hosts => true } }

    it { should contain_resources('host').with({'purge' => true}) }
  end

  describe 'with target set' do
    let(:params) { { :target => '/usr/local/etc/hosts' } }

    it { should contain_host('monkey.example.com').with({'target' => '/usr/local/etc/hosts'}) }
  end

  describe 'with host_entries' do
    context 'set to a valid hash of entries' do
      let(:params) do
        {
          :host_entries => {
            'myhost.example.com' => {
              'ip' => '10.0.0.5',
              'host_aliases' => ['myhost'],
            },
            'myhost2.example.com' => {
              'ip' => '10.0.0.6',
              'host_aliases' => ['myhost2','loghost'],
            },
          }
        }
      end

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

    context 'with host_entries containing host for fqdn' do
      let(:params) do
        {
          :host_entries => {
            'monkey.example.com' => {
              'ip'           => '10.0.0.5',
              'host_aliases' => 'monkey',
            },
            'anotherhost.example.com' => {
              'ip'           => '10.0.0.6',
              'host_aliases' => 'anotherhost',
            },
          }
        }
      end

      it {
        should_not contain_host('monkey.example.com').with({
          'ip' => '10.0.0.5',
          'host_aliases' => 'monkey',
        })
      }

      it {
        should contain_host('anotherhost.example.com').with({
          'ip' => '10.0.0.6',
          'host_aliases' => 'anotherhost',
        })
      }
    end
  end

  describe 'variable data type and content validations' do
    validations = {
      'Stdlib::IP::Address' => {
        :name    => %w(fqdn_ip),
        :valid   => ['1.2.3.4', '::1'],
        :invalid => ['localhost', %w(array), { 'ha' => 'sh' }, 3, 2.42, false, nil],
        :message => 'Error while evaluating a Resource Statement',
      },
      'boolean' => {
        :name    => %w(fqdn_entry purge_hosts),
        :valid   => [true, false],
        :invalid => ['string', %w(array), { 'ha' => 'sh' }, 3, 2.42, 'false', nil],
        :message => 'expects a Boolean value', # Puppet 4 & 5
      },
      'hash (optional)' => {
        :name    => %w(host_entries),
        :valid   => [{}],
        :invalid => ['string', 3, 2.42, %w(array), false, nil],
        :message => 'expects a value of type Undef or Hash', # Puppet 4 & 5
      },
      'array or string' => {
        :name    => %w(fqdn_host_aliases),
        :valid   => ['string', %w(array)],
        :invalid => [{ 'ha' => 'sh' }, 3, 2.42, false],
        :message => 'expects a value of type String or Array', # Puppet 4 & 5
      },
      'Stdlib::Absolutepath' => {
        :name    => %w(target),
        :valid   => ['/absolute/filepath', '/absolute/directory/'],
        :invalid => ['../invalid', %w(array), { 'ha' => 'sh' }, 3, 2.42, false, nil],
        :message => 'expects a (match for|match for Stdlib::Absolutepath =|Stdlib::Absolutepath =) Variant\[Stdlib::Windowspath.*Stdlib::Unixpath', # Puppet (4.x|5.0 & 5.1|5.x)
      },
    }

    validations.sort.each do |type, var|
      mandatory_params = {} if mandatory_params.nil?
      var[:name].each do |var_name|
        var[:params] = {} if var[:params].nil?
        var[:valid].each do |valid|
          context "when #{var_name} (#{type}) is set to valid #{valid} (as #{valid.class})" do
            let(:facts) { [mandatory_facts, var[:facts]].reduce(:merge) } if ! var[:facts].nil?
            let(:params) { [mandatory_params, var[:params], { :"#{var_name}" => valid, }].reduce(:merge) }
            it { should compile }
          end
        end

        var[:invalid].each do |invalid|
          context "when #{var_name} (#{type}) is set to invalid #{invalid} (as #{invalid.class})" do
            let(:params) { [mandatory_params, var[:params], { :"#{var_name}" => invalid, }].reduce(:merge) }
            it 'should fail' do
              expect { should contain_class(subject) }.to raise_error(Puppet::Error, /#{var[:message]}/)
            end
          end
        end
      end # var[:name].each
    end # validations.sort.each
  end # describe 'variable type and content validations'
end
