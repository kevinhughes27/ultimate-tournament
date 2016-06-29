require 'simplecov'

# save to CircleCI's artifacts directory if we're on CircleCI
if ENV['CIRCLE_ARTIFACTS']
  dir = File.join(ENV['CIRCLE_ARTIFACTS'], "coverage")
  SimpleCov.coverage_dir(dir)
else
  dir = File.join(File.dirname(__FILE__), "coverage")
  SimpleCov.coverage_dir(dir)
end

if ENV['CIRCLE_ARTIFACTS'] || ENV['COVERAGE']
  SimpleCov.start 'rails'
end

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'

if ENV['CIRCLECI']
  require 'minitest/ci'
  Minitest::Ci.new.start

  require 'minitest/retry'
  Minitest::Retry.use!(retry_count: 1)
end

OmniAuth.config.test_mode = true

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

class ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def set_tournament(tournament)
    set_subdomain(tournament.try(:handle) || tournament)
  end

  def set_subdomain(subdomain)
    @request.host = "#{subdomain}.#{Settings.host}"
  end
end

class ActiveSupport::TestCase
  fixtures :all

  def stub_constant(mod, const, value)
    original = mod.const_get(const)

    begin
      mod.instance_eval { remove_const(const); const_set(const, value) }
      yield
    ensure
      mod.instance_eval { remove_const(const); const_set(const, original) }
    end
  end

  def response_json
    JSON.parse(@response.body)
  end
end
