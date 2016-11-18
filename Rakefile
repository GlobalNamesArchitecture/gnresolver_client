require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new

task default: [:rubocop, :spec]

desc "open an irb session preloaded with this library"
task :console do
  sh "irb -I lib -I #{__dir__} -r gnresolver_client.rb"
end
