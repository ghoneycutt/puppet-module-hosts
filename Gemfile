source ENV['GEM_SOURCE'] || 'https://rubygems.org'

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

gem 'metadata-json-lint'
gem 'puppetlabs_spec_helper', '>= 1.1.1'
gem 'facter', '>= 1.7.0'
gem 'rspec-puppet'
gem 'puppet-lint'

# rspec must be v2 for ruby 1.8.7
if RUBY_VERSION >= '1.8.7' and RUBY_VERSION < '1.9'
  # rake >=11 does not support ruby 1.8.7
  gem 'rake', '~> 10.0'
  gem 'rspec', '~> 2.0'
end

