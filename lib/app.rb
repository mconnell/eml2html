# frozen_string_literal: true

require "roda"
require_relative "html_extractor"

class App < Roda
  plugin :public, root: "public"
  plugin :json

  route do |r|
    r.root do
      File.read("public/index.html")
    end

    r.public

    r.get "up" do
      { status: "ok" }
    end

    r.post "eml" do
      begin
        html = HtmlExtractor.new(r.body.read).call

        { html: html }
      rescue
        response.status = 418
        { error: "Something went wrong and I'm now a teapot" }
      end
    end
  end
end
