require "spec_helper"
include StrictMachine

describe DefinitionContext do
  describe '#state' do
    it "adds a new state to the definition" do
      klass = Class.new(StrictMachine::Base) do
        strict_machine do
          state :initial
        end
      end

      expect(klass.states.size).to eq(1)
      expect(klass.states.first.name).to eq(:initial)
    end
  end

  describe '#on' do
    it "triggers a state change" do
      klass = Class.new(StrictMachine::Base) do
        strict_machine do
          state :initial do
            on hop: :done
          end
          state :done
        end
      end

      machine = klass.new
      machine.boot!
      expect(machine.current_state).to eq(:initial)
      machine.hop
      expect(machine.current_state).to eq(:done)
    end

    it "honors guard statements" do
      klass = Class.new(StrictMachine::Base) do
        strict_machine do
          state :initial do
            on hop: :done, if: :guarded?
          end
          state :done
        end

        def guarded?
          false
        end
      end

      machine = klass.new
      machine.boot!
      expect(machine.current_state).to eq(:initial)
      expect { machine.hop }.to raise_error(GuardedTransitionError)
    end

    it "bypasses guard statements with a bang" do
      klass = Class.new(StrictMachine::Base) do
        strict_machine do
          state :initial do
            on hop: :done, if: :guarded?
          end
          state :done
        end

        def guarded?
          false
        end
      end

      machine = klass.new
      machine.boot!
      machine.hop!
      expect(machine.current_state).to eql(:done)
    end

    it "raises error on invalid state transitions" do
      klass = Class.new(StrictMachine::Base) do
        strict_machine do
          state :initial do
            on hop: :dinn
          end
        end
      end

      machine = klass.new
      machine.boot!
      expect { machine.hop }.to raise_error(StateNotFoundError)
      expect { machine.zing }.to raise_error(TransitionNotFoundError)
    end
  end

  describe '#on_entry' do
    it "gets called upon entering a state" do
      klass = Class.new(StrictMachine::Base) do
        strict_machine do
          state :initial do
            on hop: :done
          end
          state :done do
            on_entry do |previous, trigger|
              log(previous, trigger)
            end
            on_entry do |previous, trigger|
              log2(previous, trigger)
            end
          end
        end

        def log(_, _); end

        def log2(_, _); end
      end

      machine = klass.new
      expect_any_instance_of(klass).to receive(:log).with(:initial, :hop)
      expect_any_instance_of(klass).to receive(:log2).with(:initial, :hop)

      machine.boot!
      machine.hop
    end
  end

  describe '#on_transition' do
    it "gets called upon entering any state" do
      klass = Class.new(StrictMachine::Base) do
        strict_machine do
          state :initial do
            on hop: :middle
          end
          state :middle do
            on hop: :final
          end
          state :final
          on_transition do |from, to, trigger_event, duration|
            log from, to, trigger_event, duration
          end
        end

        def log(_, _, _, _); end
      end

      machine = klass.new
      expect_any_instance_of(klass).to receive(:log).with(
        :initial, :middle, :hop, any_args
      )
      expect_any_instance_of(klass).to receive(:log).with(
        :middle, :final, :hop, any_args
      )

      machine.boot!
      machine.hop
      machine.hop
    end
  end
end
