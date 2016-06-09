module StrictMachine
  module MountStateMachine
    module ClassMethods
      def mount_state_machine(klass, options = {})
        metaclass.instance_eval do
          define_method(:strict_machine_class) { klass }
          define_method(:strict_machine_options) { options }
        end
      end
    end
  end
end
