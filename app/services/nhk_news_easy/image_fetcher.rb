require "open-uri"
require "base64_image"

module NhkNewsEasy
  class ImageFetcher
    def initialize(url)
      @url = url
    end

    def fetch
      base64_image.to_s if url =~ URI::regexp
    rescue OpenURI::HTTPError
      nil
    end

    private

    attr_reader :url

    def base64_image
      Base64Image.new(content_type, image_data)
    end

    def content_type
      @_content_type ||= handle.content_type
    end

    def image_data
      @_image_data ||= handle.read
    end

    def handle
      @_handle ||= open(url)
    end
  end
end
