# frozen_string_literal: true

require "spec_helper"
require "json"

RSpec.describe "Health check" do
  describe "GET /up" do
    it "returns 200 OK and JSON body" do
      get "/up"

      expect(last_response.status).to eq(200)
      body = JSON.parse(last_response.body)
      expect(body["status"]).to eq("ok")
    end
  end
end
