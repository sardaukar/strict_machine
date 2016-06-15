require_relative "mount_state_machine/instance_methods"
require_relative "mount_state_machine/class_methods"

module StrictMachine
  module MountStateMachine
    def self.included(base)
      base.extend ClassMethods
    end
  end
end
