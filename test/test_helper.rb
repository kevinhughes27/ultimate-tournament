ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mocha/mini_test'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

class ActionController::TestCase
  include Devise::TestHelpers
end

class ActiveSupport::TestCase
  fixtures :all

  def json_response
    JSON.parse(@response.body)
  end
end
