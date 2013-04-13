module Switches
  class Collection
    def initialize(klass, instance)
      @collection = Hash.new do |collection, name|
        name = name.to_sym
        item = klass.new(name, instance)

        item.reload
        collection[name] = item
      end
    end

    def [](name)
      @collection[name.to_sym]
    end

    def reload(name)
      name = name.to_sym

      if include?(name)
        @collection[name].reload
      else
        @collection[name]
      end
    end

    def include?(name)
      @collection.keys.include?(name.to_sym)
    end
  end
end
