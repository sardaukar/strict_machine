class DummyStateMachine < StrictMachine::Base
  strict_machine do
    state :new do
      on submit: :awaiting_review
    end

    state :awaiting_review do
      on review: :under_review
    end

    state :under_review do
      on_entry { |previous, trigger| log2(previous, trigger) }
      on accept: :accepted, if: :cool_article?
      on reject: :rejected, if: :bad_article?
    end

    state :accepted
    state :rejected

    on_transition do |from, to, trigger_event, duration|
      log from, to, trigger_event, duration
    end
  end
end
