ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end

class ActionDispatch::IntegrationTest
  def sign_in(user)
    # Create a session for the user
    user_session = user.sessions.create!(user_agent: "test", ip_address: "127.0.0.1")

    # Set Current.session directly for the test
    Current.session = user_session

    # Also set a simple cookie for the integration test
    cookies[:session_id] = user_session.id
  end
end
