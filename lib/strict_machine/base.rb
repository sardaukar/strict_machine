require_relative "definition_context"

module StrictMachine
  class Base
    include MountStateMachine::InstanceMethods

    def self.strict_machine(state_attr = "state", &block)
      dc = DefinitionContext.new
      dc.instance_eval(&block)

      stored = self

      metaclass.instance_eval do
        define_method(:definition) { dc }
        define_method(:strict_machine_class) { stored }
        define_method(:strict_machine_attr) { state_attr }
      end
    end
  end
end
