# frozen_string_literal: true

require "roda"

class App < Roda
  plugin :json

  route do |r|
    r.get "up" do
      { status: "ok" }
    end
  end
end
