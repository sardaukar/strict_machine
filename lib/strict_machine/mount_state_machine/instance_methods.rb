module StrictMachine
  module MountStateMachine
    module InstanceMethods
      def trigger(*transitions)
      end

      def state
        byebug
        # self.instance_variable_get self.class.strict_machine_attr
        # self.class.strict_machine_class.definition
      end
    end
  end
end
