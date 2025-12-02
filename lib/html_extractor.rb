require "mail"

class HtmlExtractor
  def initialize(eml_string_io)
    @mail = Mail.read_from_string(eml_string_io)
  end

  def call
    return santisied(@mail.body&.decoded) if html_only_email?
    return nil if plain_text_only_email?

    santisied(@mail.html_part.body.decoded.to_s)
  end

  private

  def santisied(html)
    html.encode("UTF-8", invalid: :replace, undef: :replace, replace: "�")
        .gsub(/\r\n?/, "\n")
  end

  def html_only_email?
    !@mail.multipart? &&
      @mail.content_type&.downcase&.include?("text/html")
  end

  def plain_text_only_email?
    !@mail.multipart? &&
      @mail.content_type&.downcase&.include?("text/plain")
  end
end
