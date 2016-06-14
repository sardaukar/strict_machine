require_relative "mount_state_machine"
require_relative "definition_context"

module StrictMachine
  class Base
    def self.strict_machine(&block)
      dc = DefinitionContext.new
      dc.instance_eval(&block)

      metaclass.instance_eval do
        define_method(:definition) { dc }
      end
    end

    # def self.states
    #   definition.states
    # end

    # def boot!
    #   @state_attr = :status if @state_attr.nil?

    #   change_state(self.class.states.first.name)
    # end

    def state
      write_initial_state if current_state_attr.nil?

      current_state_attr_value
    end

    def definition
      self.class.definition
    end

    # def transition?(meth, state)
    #   definition.transition?(meth, state)
    # end

    # def trigger_transition(trigger, stored = self)
    #   dt = Time.now

    #   is_bang = !trigger.to_s.index("!").nil?
    #   transition = from_state.get_transition(trigger, is_bang)

    #   if transition.guarded? && !is_bang
    #     raise GuardedTransitionError unless stored.public_send(
    #       transition.guard
    #     )
    #   end

    #   new_state = definition.get_state_by_name(transition.to)
    #   new_state.on_entry.each do |proc|
    #     stored.instance_exec(current_state, trigger.to_sym, &proc)
    #   end

    #   duration = Time.now - dt

    #   definition.transitions.each do |proc|
    #     stored.instance_exec(
    #       current_state, new_state.name, trigger.to_sym, duration, &proc
    #     )
    #   end

    #   change_state(new_state.name)
    # end

    ###

    # def respond_to?(meth, _include_private = false)
    #   transition?(meth, current_state)
    # end

    # def method_missing(meth, *_args)
    #   if transition?(meth, current_state)
    #     trigger_transition(meth, mounted_on || self)
    #   else
    #     raise TransitionNotFoundError, meth
    #   end
    # end

    private

    def current_state_attr_value
      instance_variable_get "@#{@state_attr}"
    end

    def write_initial_state
      instance_variable_set "@#{@state_attr}".to_sym,
                            definition.initial_state_name
    end

    # def from_state
    #   definition.get_state_by_name(current_state)
    # end

    def change_state(new_state, _is_initial = false)
      instance_variable_set "@#{@state_attr}".to_sym, new_state
    end
  end
end
