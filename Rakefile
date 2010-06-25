require File.expand_path('lib/boot', File.dirname(__FILE__))

require 'rake'
require 'spec/rake/spectask'

require 'thief'

Spec::Rake::SpecTask.new(:spec)
task :default => :spec

Thief.setup do |config|
  config.database = File.expand_path('config/database.yml', File.dirname(__FILE__))
end

namespace :thief do
  task :create_tables do
    Thief.create_tables
  end
end