class Feature
  attr_reader :name

  def initialize(name, instance)
    @name = name
    @instance = instance
    @percentage = 0.0
    @on = false
  end

  def reload
    if data = @instance.get(self)
      @percentage = data["percentage"].to_f

      if @percentage > 0.0
        @on = true
      end
    end

    self
  end

  def on(percentage = nil)
    @on = true
    @percentage = percentage || 100.0
    updated
    self
  end

  def off
    @on = false
    @percentage = 0.0
    updated
    self
  end

  def on?
    @on == true
  end

  def off?
    !on?
  end

  def percentage
    @percentage || 0.0
  end

  def inspect
    output = "#<Feature"
    output += " name:#{@name}"

    if on?
      if @percentage == 100.0
        output += " on"
      else
        output += " on:#{@percentage}"
      end
    else
      output += " off"
    end

    output += ">"
  end

  def updated
    @instance.set(self)
    @instance.notify(self)
  end

  def to_json
    JSON.generate(
      name: name,
      percentage: percentage
    )
  end
end
