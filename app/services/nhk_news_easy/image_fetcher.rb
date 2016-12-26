require "open-uri"

module NhkNewsEasy
  class ImageFetcher
    def initialize(url)
      @url = url
    end

    def fetch
      if url =~ URI::regexp
        handle = open(url)
        base64 = Base64.encode64(handle.read)
        "data:#{handle.content_type};base64,#{base64}"
      end
    rescue OpenURI::HTTPError
      nil
    end

    private

    attr_reader :url
  end
end
