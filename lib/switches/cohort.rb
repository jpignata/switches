module Switches
  class Cohort
    include JSONSerializer

    attr_reader :name

    def self.collection(instance)
      Collection.new(self, instance)
    end

    def initialize(name, instance)
      @name = name
      @instance = instance
      @members = Set.new
    end

    def reload
      if attributes = @instance.get(self)
        @members = attributes["members"].to_set
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

    def key
      [type, name].join(":")
    end

    private

    def updated
      @instance.set(self)
      @instance.notify(self)
      self
    end
  end
end
