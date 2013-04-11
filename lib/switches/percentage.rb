module Switches
  class Percentage
    LOWER = 0.0
    UPPER = 100.0

    include Comparable

    attr_reader :value
    protected :value

    def initialize(value)
      @value = clip(value)
    end

    def <=>(other)
      @value <=> other.value
    end

    def include?(identifier)
      Percentage(Zlib.crc32(identifier) % UPPER) < self
    end

    def to_i
      @value.to_i
    end

    def to_f
      @value.to_f
    end

    def to_s
      "#{@value}%"
    end

    def inspect
      to_s
    end

    def min?
      @value == LOWER
    end

    def max?
      @value == UPPER
    end

    private

    def clip(value)
      [LOWER, value.to_i, UPPER].sort[1]
    end
  end
end

def Percentage(value)
  return value if value.kind_of?(Switches::Percentage)
  Switches::Percentage.new(value)
end
