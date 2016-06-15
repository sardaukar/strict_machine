require_relative "definition/state"

module StrictMachine
  class DefinitionContext
    attr_reader :states, :transitions

    def initialize
      @states = []
      @transitions = []
    end

    def get_state_by_name(name)
      @states.each do |this_state|
        return this_state if this_state.name == name.to_sym
      end

      raise StateNotFoundError, name
    end

    def initial_state_name
      @states.first.name
    end

    def run_transitions(instance, current_state, new_state, trigger, duration)
      @transitions.each do |proc|
        instance.instance_exec(
          current_state, new_state, trigger, duration, &proc
        )
      end
    end

    ### DSL

    def state(name, &block)
      @states << State.new(name)
      instance_eval(&block) if block_given?
    end

    def on(hash)
      @states.last.add_transition hash
    end

    def on_entry(&block)
      @states.last.add_on_entry(block)
    end

    def on_transition(&block)
      @transitions << block
    end

    ###
  end
end
