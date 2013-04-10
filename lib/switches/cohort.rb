class Cohort
  attr_reader :name

  def initialize(name, instance)
    @name = name
    @instance = instance
    @members = Set.new
  end

  def reload
    if data = @instance.get(self)
      @members = data["members"].to_set
    end

    self
  end

  def include?(identifier)
    @members.include?(identifier)
  end

  def add(member)
    @members.add(member.to_s)
    updated
  end

  def remove(member)
    @members.delete(member.to_s)
    updated
  end

  def inspect
    output = "#<Cohort #{@name}"
    output += "; #{@members.count} member"
    output += "s" unless @members.count == 1
    output += ">"
  end

  def to_json
    {
      name: name,
      members: members
    }.to_json
  end

  def members
    @members.to_a
  end

  private

  def updated
    @instance.set(self)
    @instance.notify(self)
    self
  end
end
