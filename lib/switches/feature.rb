class Feature
  attr_reader :name, :percentage

  def initialize(name, instance)
    @name = name
    @instance = instance
    @percentage = Percentage(0)
    @cohorts = Set.new
  end

  def reload
    if data = @instance.get(self)
      @percentage = Percentage(data["percentage"])
      @cohorts = data["cohorts"].to_set
    end

    self
  end

  def on(numeric = 100)
    @percentage = Percentage(numeric)
    updated
  end

  def off
    @percentage = Percentage(0)
    updated
  end

  def add(cohort_name)
    @cohorts.add(cohort_name.to_s)
    updated
  end

  def remove(cohort_name)
    @cohorts.delete(cohort_name.to_s)
    updated
  end

  def inspect
    output = "#<Feature #{@name}; #{@percentage}"
    output += "; #{@cohorts.to_a.join(", ")}" if @cohorts.any?
    output += ">"
  end

  def to_json
    {
      name: name,
      percentage: percentage,
      cohorts: @cohorts.to_a
    }.to_json
  end

  def cohorts
    @cohorts.to_a
  end

  def on?(identifier)
    return true if @percentage.max?

    in_cohort?(identifier) || in_percentage?(identifier)
  end

  private

  def in_cohort?(identifier)
    @cohorts.any? do |cohort|
      @instance.cohort(cohort).include?(identifier)
    end
  end

  def in_percentage?(identifier)
    return false if @percentage.min?

    @percentage.include?(identifier)
  end

  def updated
    @instance.set(self)
    @instance.notify(self)
    self
  end
end
