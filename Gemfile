source 'https://rubygems.org'

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

gem 'metadata-json-lint'
gem 'puppetlabs_spec_helper', '~> 1.1.1'
gem 'puppet-lint', '>= 1.0.0'
gem 'rspec-puppet', '~> 2.3.2'
gem 'rake', '~> 10.5.0'

# rspec must be v2 for ruby 1.8.7
if RUBY_VERSION >= '1.8.7' and RUBY_VERSION < '1.9'
  gem 'rspec', '~> 3.1.0'
end
