require_relative "definition/state"

module StrictMachine
  class DefinitionContext
    attr_reader :states, :transitions
    attr_accessor :mounted_on

    def initialize
      @states = []
      @transitions = []
    end

    def transition?(name, state)
      is_bang = (name[-1] == "!")
      name = is_bang ? name[0..-2] : name

      @states.each do |this_state|
        next unless this_state.name.to_sym == state.to_sym

        this_state.transition_definitions.each do |this_transition|
          return true if this_transition.name == name.to_sym
        end
      end

      false
    end

    def get_state_by_name(name)
      @states.each do |this_state|
        return this_state if this_state.name == name
      end

      raise StateNotFoundError, name
    end

    ###

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
