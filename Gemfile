source 'http://rubygems.org'

gem 'data_mapper'
gem 'fastthread'
gem 'levenshtein'
gem 'json'

gem 'thor'
gem 'rake'

group :application do
  gem 'sinatra', :require => 'sinatra/base'
end

## sources
group :dapi do
  gem 'rest-client', :require => 'rest_client'
  gem 'yajl-ruby', :require => 'yajl'
end

group :wikipedia do
  gem 'rubyzip', :require => 'zip/zip'
end

## databases
group :sqlite3 do
  gem 'dm-sqlite-adapter'  
end

group :mysql do
  gem 'dm-mysql-adapter'
end

group :postgresql do
  gem 'dm-postgres-adapter'
end

## environments
group :test do
  gem 'rspec'
end