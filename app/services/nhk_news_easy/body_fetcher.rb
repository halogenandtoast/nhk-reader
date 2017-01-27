require "open-uri"
require "buffer_utils"

module NhkNewsEasy
  class BodyFetcher
    def initialize(url)
      @url = url
    end

    def fetch
      doc = Nokogiri::HTML(open(url))
      sanitize doc.css("#newsarticle").to_s
    end

    private

    attr_reader :url

    def sanitize(body)
      Sanitizer.new(body).sanitize
    end
  end

  class Sanitizer
    PERMITTED_TAGS = %w(ruby rt p span)
    PERMITTED_ATTRIBUTES = {'span' => ['class']}

    def initialize(html)
      @html = html
    end

    def sanitize
      BufferUtils.no_output do
        Sanitize.fragment(
          html_with_lookup,
          elements: PERMITTED_TAGS,
          attributes: PERMITTED_ATTRIBUTES
        )
      end
    end

    private

    attr_reader :html

    def html_with_lookup
      html.gsub(/<a[^>]*>/, "<span class=\"lookup\">").gsub("</a>", "</span>")
    end
  end
end
