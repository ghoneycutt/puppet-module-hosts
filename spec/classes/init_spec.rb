require 'spec_helper'
describe 'hosts' do
  # There is no conditional logic based on the platform, so this tests once
  # instead of wasting resources testing this many times with different
  # platform data.
  on_supported_os({
    supported_os: [{ 'operatingsystem' => 'RedHat', 'operatingsystemrelease' => ['8'] }]
  }).each do |os, facts|
    context "on #{os} with default values for class parameters" do
      let(:facts) { facts }

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_class('hosts') }

      it { is_expected.to have_host_resource_count(0) }
    end

    context 'with hosts specified' do
      let(:facts) { facts }
      let(:params) do
        {
          hosts: {
            short_name: {
              ensure: 'present',
              host_aliases: ['short_name.qualified'],
              ip: '10.2.3.4',
            }
          }
        }
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to contain_class('hosts') }

      it { is_expected.to have_host_resource_count(1) }

      it { is_expected.to contain_host('short_name').with_ensure('present').with_host_aliases(['short_name.qualified']).with_ip('10.2.3.4') }
    end
  end

  describe 'on unsupported platform' do
    let :facts do
      { :os['family'] => 'unsupported' }
    end

    it 'does not fail' do
      expect do
        is_expected.to contain_class('hosts')
      end
    end
  end
end
