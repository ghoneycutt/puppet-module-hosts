# RSpec.configure specified twice due to bug in puppetlabs_spec_helper.
# https://tickets.puppetlabs.com/browse/PDK-916
RSpec.configure do |config|
  config.mock_with :rspec
end
require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |config|
  config.hiera_config = 'spec/fixtures/hiera/hiera.yaml'
  config.before :each do
    # Ensure that we don't accidentally cache facts and environment between
    # test cases.  This requires each example group to explicitly load the
    # facts being exercised with something like
    # Facter.collection.loader.load(:ipaddress)
    Facter.clear
    Facter.clear_messages
  end
  config.default_facts = {
    :fqdn        => 'monkey.example.com',
    :hostname    => 'monkey',
    :ipaddress   => '10.1.2.3',
  }
end
