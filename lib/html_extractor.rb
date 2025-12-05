require "mail"

class HtmlExtractor
  def initialize(eml_string_io)
    @mail = Mail.read_from_string(eml_string_io)
  end

  def call
    return sanitised(html: @mail.body&.decoded, encoding: encoding_for(@mail)) if html_only_email?
    return nil if plain_text_only_email?

    sanitised(html: @mail.html_part.body.decoded, encoding: encoding_for(@mail.html_part))
  end

  private

  def sanitised(html:, encoding:)
    return if html.nil?

    source_encoding = encoding || "UTF-8"

    html
      .force_encoding(source_encoding)
      .encode("UTF-8")
      .gsub(/\r\n?/, "\n")
  end

  def encoding_for(part)
    part.charset || @mail.charset || "UTF-8"
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
