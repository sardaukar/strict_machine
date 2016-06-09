module StrictMachine
  class TransitionDefinition
    attr_reader :name, :to, :guard

    def initialize(definition)
      definition.each_pair do |k, v|
        if k == :if
          @guard = v.to_sym
        else
          @name = k.to_sym
          @to = v.to_sym
        end
      end
    end

    def guarded?
      !@guard.nil?
    end
  end
end
