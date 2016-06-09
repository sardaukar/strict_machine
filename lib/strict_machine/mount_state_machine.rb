require_relative "mount_state_machine/initializer"
require_relative "mount_state_machine/class_methods"

module StrictMachine
  module MountStateMachine
    def self.included(base)
      base.extend ClassMethods
      base.public_send :prepend, Initializer
    end

    def current_state
      @state_machine.current_state
    end

    def state_attr
      @state_machine.state_attr
    end

    ###

    def method_missing(meth, *args, &block)
      if @state_machine.transition?(meth, current_state)
        @state_machine.trigger_transition(meth, self)
      else
        super
      end
    end

    def respond_to?(meth, _include_private = false)
      @state_machine.transition?(meth, current_state)
    end
  end
end
