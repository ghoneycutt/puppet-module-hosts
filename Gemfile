source ENV['GEM_SOURCE'] || 'https://rubygems.org'

if puppetversion = ENV['PUPPET_GEM_VERSION'] || "~> 5.x"
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end

gem 'rake'
gem 'metadata-json-lint',                               :require => false
gem 'puppetlabs_spec_helper',                           :require => false
gem 'rspec-puppet', '~> 2.0',                           :require => false
gem 'puppet-lint', '~> 2.0',                            :require => false
gem 'puppet-lint-absolute_classname-check',             :require => false
gem 'puppet-lint-alias-check',                          :require => false
gem 'puppet-lint-empty_string-check',                   :require => false
gem 'puppet-lint-file_ensure-check',                    :require => false
gem 'puppet-lint-file_source_rights-check',             :require => false
gem 'puppet-lint-leading_zero-check',                   :require => false
gem 'puppet-lint-spaceship_operator_without_tag-check', :require => false
gem 'puppet-lint-trailing_comma-check',                 :require => false
gem 'puppet-lint-undef_in_function-check',              :require => false
gem 'puppet-lint-unquoted_string-check',                :require => false
gem 'puppet-lint-variable_contains_upcase',             :require => false

if puppetversion && puppetversion < '5.0'
  gem 'semantic_puppet', :require => false
end

gem 'puppetlabs_spec_helper', '2.0.2',    :require => false if RUBY_VERSION >= '1.8.7' && RUBY_VERSION < '1.9'
gem 'puppetlabs_spec_helper', '>= 2.0.0', :require => false if RUBY_VERSION >= '1.9'
gem 'parallel_tests',         '<= 2.9.0', :require => false if RUBY_VERSION < '2.0.0'

group :documentation do
  gem 'yard',           require: false
  gem 'redcarpet',      require: false
  gem 'puppet-strings', require: false
end
