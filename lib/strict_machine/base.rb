require_relative "definition_context"

module StrictMachine
  class Base
    def self.strict_machine(state_attr = "state", &block)
      dc = DefinitionContext.new
      dc.instance_eval(&block)

      stored = self

      metaclass.instance_eval do
        define_method(:definition) { dc }
        define_method(:strict_machine_class) { stored }
        define_method(:strict_machine_attr) { "@#{state_attr}".to_sym }
      end
    end

    def self.states
      definition.states
    end

    def state
      write_initial_state if current_state_attr_value.nil?

      current_state_attr_value
    end

    def definition
      self.class.definition
    end

    def trigger(*transitions)
      transitions.map {|t| change_state(t, state) }

      true
    end

    private

    def change_state(trigger, current_state_name)
      dt = Time.now
      current_state = definition.get_state_by_name(current_state_name)
      is_bang, transition = current_state.get_transition(trigger)

      if transition.guarded? && !is_bang
        raise GuardedTransitionError unless self.public_send(
          transition.guard
        )
      end

      new_state = definition.get_state_by_name(transition.to)
      new_state.on_entry.each do |proc|
        self.instance_exec(current_state_name, trigger.to_sym, &proc)
      end

      duration = Time.now - dt

      definition.transitions.each do |proc|
        self.instance_exec(
          current_state_name, new_state.name, trigger.to_sym, duration, &proc
        )
      end

      write_state(new_state.name)
    end

    def current_state_attr_value
      instance_variable_get state_attr_name
    end

    def state_attr_name
      self.class.strict_machine_attr
    end

    def write_initial_state
      write_state(definition.initial_state_name)
    end

    def write_state(value)
      instance_variable_set state_attr_name, value
    end
  end
end
