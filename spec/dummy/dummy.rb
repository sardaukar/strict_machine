class Dummy
  include StrictMachine::MountStateMachine

  mount_state_machine DummyStateMachine, state: "meh"

  def cool_article?
    true
  end

  def bad_article?
    false
  end

  def log(_, _, _, _); end

  def log2(_, _); end

  def send_reports; end
end
