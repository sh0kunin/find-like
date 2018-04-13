require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'
require 'rspec/core/rake_task'
require 'yard'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

YARD::Rake::YardocTask.new(:docs) do |t|
  t.files   = ['lib/**/*.rb']
  t.options = ['--output-dir', './docs/html', '--markup', 'markdown']
end

task doc: :docs

RuboCop::RakeTask.new(:rubocop) do |t|
  t.options = ['--display-cop-names']
end

Rake::TestTask.new do |t|
  task :test => 'clean'
  t.warning = true
  t.verbose = true
end

task :t => :test

task :ci do
  begin
    Rake::Task[:rubocop].invoke
    Rake::Task[:docs].invoke
    Rake::Task[:spec].invoke
  ensure
    Rake::Task[:spec].invoke
  end
end
