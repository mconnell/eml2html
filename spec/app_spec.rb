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

  describe "POST /eml" do
    context "eml content supplied in the request" do
      let(:eml) do
        <<~EML
        Content-Type: text/html

        <p>
          Ring ring ring ring ring ring ring ring.. BANANA PHONE!
        </p>
        EML
      end

      it "returns json with the HTML payload" do
        post "/eml", eml, { "CONTENT_TYPE" => "text/plain" }

        body = JSON.parse(last_response.body)
        expect(body["html"]).to eq(
          <<~HTML
          <p>
            Ring ring ring ring ring ring ring ring.. BANANA PHONE!
          </p>
          HTML
        )
      end
    end

    context "shite content supplied" do
      let(:eml) do
        <<~EML
        3q2+7wAAAAAAAAAAAAAAAAAAAAAAAP//fw==
        EML
      end

      it "gracefully errors and makes a cup of tea" do
        post "/eml", eml, { "CONTENT_TYPE" => "text/plain" }

        expect(last_response.status).to eq(418)
        body = JSON.parse(last_response.body)
        expect(body["error"]).to(
          eq("Something went wrong and I'm now a teapot")
        )
      end
    end
  end
end
