require "mail"

class HtmlExtractor
  def initialize(eml_string_io)
    @mail = Mail.read_from_string(eml_string_io)
  end

  def call
    @mail.html_part.body.decoded.to_s
  end
end
