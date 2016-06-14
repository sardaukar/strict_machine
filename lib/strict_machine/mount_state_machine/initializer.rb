module StrictMachine
  module MountStateMachine
    module Initializer
      def initialize(*args)
        if self.class.respond_to?(:strict_machine_class)
          @state_machine = self.class.strict_machine_class.new
          @state_machine.mounted_on = self

          options = self.class.strict_machine_options
          state_attr = options.fetch(:state, :status)
          @state_machine.state_attr = state_attr

          @state_machine.boot!
        end

        super
      end
    end
  end
end
