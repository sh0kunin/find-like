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

Rake::TestTask.new(:unit) do |t|
  t.libs << 'spec'
  t.libs << 'lib'
  t.test_files = FileList['spec/**/test_*.rb']
  t.warning = false
end


task :test do
  begin
    Rake::Task[:spec].invoke
    Rake::Task[:unit].invoke
  ensure
    Rake::Task[:spec].invoke
  end
end

task :ci do
  begin
    Rake::Task[:docs].invoke
    Rake::Task[:spec].invoke
    Rake::Task[:test].invoke
  ensure
    Rake::Task[:spec].invoke
  end
end
