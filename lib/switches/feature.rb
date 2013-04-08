class Feature
  def initialize(name)
    @name = name
  end

  def on
    @on = true
  end

  def on?
    @on == true
  end
end
