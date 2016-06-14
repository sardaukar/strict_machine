require "spec_helper"

describe "mounted StrictMachine" do
  context "state shifting" do
    require_relative "dummy/dummy_state_machine"
    require_relative "dummy/dummy"

    let!(:dummy) { Dummy.new(2) }

    it "preserves passed arguments to initializer" do
      expect(dummy.a).to eq(2)
    end

    it "has an initial state" do
      expect(dummy.state).to eq(:new)
    end

    it "shifts state" do
      dummy.trigger(:submit)

      expect(dummy.state).to eq(:awaiting_review)
    end

    it "honors guard statements" do
      dummy.trigger(:submit, :review)

      expect { dummy.trigger(:reject) }.to raise_error(GuardedTransitionError)

      expect(dummy.state).to eq(:under_review)
    end

    it "bypasses guard statements with bangs" do
      dummy.trigger(:submit, :review, :reject!)

      expect(dummy.state).to eq(:rejected)
    end

    it "calls on_transition blocks" do
      expect(dummy).to receive(:log)

      dummy.trigger(:submit)
    end

    it "sets state to the given status option name" do
      expect(dummy.state_attr).to eq("meh")
    end
  end
end
