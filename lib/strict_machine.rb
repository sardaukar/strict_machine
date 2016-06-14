require_relative "ext/object"

module StrictMachine
  VERSION = "0.2.0".freeze

  class << self; attr_accessor :list; end
end

class StateNotFoundError < StandardError; end
class InvalidTransitionError < StandardError; end
class TransitionNotFoundError < StandardError; end
class GuardedTransitionError < StandardError; end

require_relative "strict_machine/mount_state_machine"
require_relative "strict_machine/base"
