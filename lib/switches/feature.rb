class Feature
  def initialize(name)
    @name = name
  end

  def on(percentage = nil)
    @on = true
    @percentage = percentage || 100
  end

  def off
    @on = false
    @percentage = 0
  end

  def on?
    @on == true
  end

  def off?
    !on?
  end

  def percentage
    @percentage || 0
  end

  def inspect
    output = "#<Feature"
    output += " name:#{@name}"

    if on?
      if @percentage == 100
        output += " on"
      else
        output += " on:#{@percentage}"
      end
    else
      output += " off"
    end

    output += ">"
  end
end
