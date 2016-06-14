require_relative "ext/object"

module StrictMachine
  VERSION = "0.1.1".freeze

  class << self; attr_accessor :list; end
end

class StateNotFoundError < StandardError; end
class InvalidTransitionError < StandardError; end
class TransitionNotFoundError < StandardError; end
class GuardedTransitionError < StandardError; end

require_relative "strict_machine/base"
