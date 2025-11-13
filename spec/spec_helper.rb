# frozen_string_literal: true

require "rack/test"
require "rspec"

ENV["RACK_ENV"] = "test"

require_relative "../lib/app"
require_relative "../lib/html_extractor"

run App.freeze.app if defined?(run)

RSpec.configure do |config|
  config.include Rack::Test::Methods

  def app
    App.app
  end
end
