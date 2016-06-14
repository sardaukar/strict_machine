module StrictMachine
  module MountStateMachine
    module ClassMethods
      def mount_state_machine(klass, options = {})
        state_attr = options.fetch(:state, :state)

        metaclass.instance_eval do
          define_method(:strict_machine_class) { klass }
          define_method(:strict_machine_attr) { "@#{state_attr}".to_sym }
        end
      end
    end
  end
end
