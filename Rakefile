require File.expand_path('../lib/boot', __FILE__)

require 'rake'
require 'spec/rake/spectask'

require 'thief'

Spec::Rake::SpecTask.new(:spec)
task :default => :spec

db_config = File.expand_path('../config/database.yml', __FILE__)
Thief.setup(db_config)

namespace :thief do
  task :create_tables do
    Thief.create_tables
  end
end