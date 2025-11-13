# frozen_string_literal: true

require "spec_helper"
require "json"

RSpec.describe "Health check" do
  describe "GET /" do
    it "returns 200 OK and renders a template" do
      get "/"

      expect(last_response.status).to eq(200)
      expect(last_response.body).to include("EML to HTML")
    end
  end

  describe "GET /up" do
    it "returns 200 OK and JSON body" do
      get "/up"

      expect(last_response.status).to eq(200)
      body = JSON.parse(last_response.body)
      expect(body["status"]).to eq("ok")
    end
  end
end
