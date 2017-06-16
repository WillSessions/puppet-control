source ENV['GEM_SOURCE'] || 'https://rubygems.org'

gem 'puppet', '~> 4.10', '>= 4.10.1'
gem 'puppetlabs_spec_helper'
gem 'puppet-lint'
gem 'r10k'

# rspec must be v2 for ruby 1.8.7
if RUBY_VERSION >= '1.8.7' && RUBY_VERSION < '1.9'
  gem 'rspec', '~> 2.0'
  gem 'rake', '~> 10.0'
else
  # rubocop requires ruby >= 1.9
  gem 'rubocop'
end
