require "open-uri"

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
      no_output do
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

    def no_output
      begin
        original_stderr = $stderr.clone
        original_stdout = $stdout.clone
        $stderr.reopen(File.new('/dev/null', 'w'))
        $stdout.reopen(File.new('/dev/null', 'w'))
        retval = yield
      rescue Exception => e
        $stdout.reopen(original_stdout)
        $stderr.reopen(original_stderr)
        raise e
      ensure
        $stdout.reopen(original_stdout)
        $stderr.reopen(original_stderr)
      end
      retval
    end
  end
end
