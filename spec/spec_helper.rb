require "bundler/setup"
require "byebug"

require "strict_machine"

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include RSpec::Matchers
  config.mock_with :rspec
  config.order = "random"
end
