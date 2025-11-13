require "mail"

class HtmlExtractor
  def initialize(eml_string_io)
    @mail = Mail.read_from_string(eml_string_io)
  end

  def call
    return @mail.body&.decoded if html_only_email?
    return nil if plan_text_only_email?

    @mail.html_part.body.decoded.to_s
  end

  private

  def html_only_email?
    !@mail.multipart? &&
      @mail.content_type&.downcase&.include?("text/html")
  end

  def plan_text_only_email?
    !@mail.multipart? &&
      @mail.content_type&.downcase&.include?("text/plain")
  end
end
