require 'spec_helper'
describe 'hosts' do

  describe 'class hosts' do

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

    context 'with host specified as not of type hash' do
      let(:params) { { :keys => [ 'not', 'a', 'hash' ] } }

      it 'should fail' do
        expect {
          should include_class('hosts')
        }.to raise_error(Puppet::Error)
      end
    end
  end
end
