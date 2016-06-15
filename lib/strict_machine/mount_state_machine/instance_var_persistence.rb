module StrictMachine
  module MountStateMachine
    module InstanceVarPersistence
      def current_state_attr_value
        instance_variable_get state_machine_attr_name
      end

      def write_initial_state
        write_state(definition.initial_state_name)
      end

      def write_state(value)
        instance_variable_set state_machine_attr_name, value
      end

      private

      def state_machine_attr_name
        "@#{self.class.strict_machine_attr}"
      end
    end
  end
end
