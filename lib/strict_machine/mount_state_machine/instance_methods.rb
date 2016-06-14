module StrictMachine
  module MountStateMachine
    module InstanceMethods
      def trigger(*transitions)
        transitions.map {|t| change_state(t, state) }

        true
      end

      def state
        if current_state_attr_value.nil?
          write_initial_state
        end

        current_state_attr_value
      end

      def state_attr
        self.class.strict_machine_attr.to_s.gsub("@",'')
      end

      private

      def current_state_attr_value
        instance_variable_get state_machine_attr_name
      end

      def write_initial_state
        write_state(definition.initial_state_name)
      end

      def write_state(value)
        instance_variable_set state_machine_attr_name, value
      end

      def state_machine_attr_name
        self.class.strict_machine_attr
      end

      def definition
        self.class.strict_machine_class.definition
      end

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
          self.instance_exec(current_state, trigger.to_sym, &proc)
        end

        duration = Time.now - dt

        definition.transitions.each do |proc|
          self.instance_exec(
            current_state, new_state.name, trigger.to_sym, duration, &proc
          )
        end

        write_state(new_state.name)
      end
    end
  end
end