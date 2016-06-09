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

    def get_transition(name)
      name = name.to_s
      is_bang = name.end_with?("!")
      name = name[0..-2] if is_bang

      @transition_definitions.each do |this_transition|
        return is_bang, this_transition if this_transition.name == name.to_sym
      end

      raise TransitionNotFoundError, name
    end

    def add_on_entry(proc)
      @on_entry << proc
    end

    def run_on_entries(instance, current_state_name, trigger)
      @on_entry.each do |proc|
        instance.instance_exec(current_state_name, trigger, &proc)
      end
    end
  end
end
