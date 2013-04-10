class Cohorts
  def initialize(instance)
    @cohorts ||= Hash.new do |cohorts, name|
      name = name.to_sym
      cohorts[name] = Cohort.new(name, instance).reload
    end
  end

  def [](name)
    @cohorts[name.to_sym]
  end
end
