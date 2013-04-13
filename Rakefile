$: << "lib"

require "rspec/core/rake_task"
require "switches/tasks"

RSpec::Core::RakeTask.new("spec:unit") do |task|
  task.pattern = FileList["spec/unit/**/*_spec.rb"]
end

RSpec::Core::RakeTask.new("spec:integration") do |task|
  task.pattern = FileList["spec/integration/**/*_spec.rb"]
end

RSpec::Core::RakeTask.new("spec")

task default: "spec:unit"
