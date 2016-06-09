require_relative "transition_definition"

module StrictMachine
  class State
    attr_reader :name, :transition_definitions, :on_entry

    def initialize(name)
      @name = name.to_sym
      @transition_definitions = []
      @on_entry = []
    end

    def add_transition(transition_definition)
      @transition_definitions << TransitionDefinition.new(
        transition_definition
      )
    end

    def get_transition(name, is_bang)
      name = name [0..-2] if is_bang

      @transition_definitions.each do |this_transition|
        return this_transition if this_transition.name == name.to_sym
      end

      raise TransitionNotFoundError, name
    end

    def add_on_entry(proc)
      @on_entry << proc
    end
  end
end
