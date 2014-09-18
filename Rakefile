require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new

namespace :spec do
  desc "Run Rspec test pushing Coverage results"
  task :coveralls do
    system "coveralls push"
  end
end

task :default => :spec
task :test => :spec
