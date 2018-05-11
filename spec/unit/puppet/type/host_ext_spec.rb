require 'spec_helper'
require 'puppet/type/host_ext'

describe Puppet::Type.type(:host_ext) do
  let(:default_config) do
    {
      name: 'localhost at 127.0.0.1',
    }
  end
  let(:config) do
    default_config
  end
  let(:host) do
    described_class.new(config)
  end

  it 'should add to catalog with raising an error' do
    catalog = Puppet::Resource::Catalog.new
    expect {
      catalog.add_resource host
    }.to_not raise_error
  end

  it 'should require a name' do
    expect {
      described_class.new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'should have composite name set hostname' do
    expect(host[:hostname]).to eq('localhost')
  end

  it 'should have composite name set ip' do
    expect(host[:ip]).to eq('127.0.0.1')
  end

  it 'should handle host_aliases' do
    config[:host_aliases] = ['localhost.localdomain']
    expect(host[:host_aliases]).to eq('localhost.localdomain')
  end

  it 'should handle IPv4 ip' do
    config[:ip] = '10.0.0.1'
    expect(host[:ip]).to eq('10.0.0.1')
  end

  it 'should handle IPv6 ip' do
    config[:ip] = '2001:0db8:85a3:0000:0000:8a2e:0370:7334'
    expect(host[:ip]).to eq('2001:0db8:85a3:0000:0000:8a2e:0370:7334')
  end
end
