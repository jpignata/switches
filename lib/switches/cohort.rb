module Switches
  class Cohort
    include JSONSerializer

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

    def as_json
      {
        name: name,
        members: members
      }
    end

    def members
      @members.to_a
    end

    def type
      "cohort"
    end

    private

    def updated
      @instance.set(self)
      @instance.notify(self)
      self
    end
  end
end
