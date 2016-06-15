require_relative "instance_var_persistence"

require "benchmark"

module StrictMachine
  module MountStateMachine
    module InstanceMethods
      include InstanceVarPersistence

      def trigger(*transitions)
        transitions.map { |t| change_state(t, state) }

        true
      end

      def state
        write_initial_state if current_state_attr_value.nil?

        current_state_attr_value
      end

      def state_attr
        self.class.strict_machine_attr.to_s
      end

      def states
        definition.states
      end

      private

      def definition
        self.class.strict_machine_class.definition
      end

      def change_state(trigger, current_state_name)
        new_state = nil

        duration = Benchmark.measure do
          is_bang, transition = current_state_obj.get_transition(trigger)

          if transition.guarded? && !is_bang
            raise GuardedTransitionError unless public_send(transition.guard)
          end

          new_state = definition.get_state_by_name(transition.to)
          new_state.run_on_entries(self, current_state_name, trigger.to_sym)
        end.real

        definition.run_transitions(
          self, current_state_name, new_state.name, trigger.to_sym, duration
        )

        write_state(new_state.name)
      end

      def current_state_obj
        definition.get_state_by_name(current_state_attr_value)
      end
    end
  end
end
