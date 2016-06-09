# StrictMachine

Easily add state-machine functionality to your Ruby classes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'strict_machine'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install strict_machine

## Usage

You can use this gem in two ways - either by embedding a state machine onto
your class, or by mounting a separate class.

### Embedded

```ruby
class A < StrictMachine::Base
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

  def log(from, to, trigger_event, duration)
   # ...
  end
end
```

### Mounting

(using same class A as previous example, minus the `log` method)

```ruby
class B
  include StrictMachine::MountStateMachine

  mount_state_machine A

  def log(from, to, trigger_event, duration)
   # ...
  end
end
```

**NOTE**: when mounting, the methods referenced should always be on the class doing the mounting, not on the state machine one!

### Object extensions

Whether embedding or mounting, an object instance will have the following
methods added to it:

- `#state` returns the current state's name
- `#trigger(*transitions)` triggers the given transition(s) by name
- `#state_attr` the name of the state attribute being used
- `#states` list of `State` objects in the machine's definition

and an object's class will have:

- `#definition` the DSL evaluation context object
- `#strict_machine_attr` the name of the attribute to store state in
- `#strict_machine_class` either the class containing the state machine, when
mounting, or `self` when embedding
- `#strict_machine` the DSL hook

### Internals

The gem works by storing, at the object's class level, the state machine's
definition and the name of the state storage attribute. Every instance of the class embedding or mounting a state machine will have its own state (stored in said attribute (by default `state`), and upon transitions, the current state and the transition requested will be passed to `#change_state` in
`InstanceMethods` and a new state will be reached (and `true` returned), or
an exception will be raised. Existing exceptions:

- `StateNotFoundError` tried to transition to a non-existing state
- `TransitionNotFoundError` the transition requested does not exist
- `GuardedTransitionError` the guard condition for the transition was not met

You can bypass the guard condition on a transition by adding a bang `!` to the
transition's name, i.e.,

```ruby
  obj.trigger('transition!') # bypass guards
```

## The DSL

Here's a complete example:

```ruby
strict_machine do
  state :new do
    on submit: :awaiting_review
  end

  state :awaiting_review do
    on review: :under_review
  end

  state :under_review do
    on_entry { |previous, trigger| some_method(previous, trigger) }
    on accept: :accepted, if: :cool_article?
    on reject: :rejected, if: :bad_article?
  end

  state :accepted
  state :rejected

  on_transition do |from, to, trigger_event, duration|
    log from, to, trigger_event, duration
  end
end
```

Guards (the `:if`s on `on` calls) must return `true` in order to pass.

When mounting, you can specify the state attribute's name with:

`mount_state_machine SomeClass, state: "meh"`

And when embedding:

`strict_machine("meh") do ....`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `strict_machine.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sardaukar/strict_machine.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

