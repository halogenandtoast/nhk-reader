class Base64Image
  def initialize(content_type, data)
    @content_type = content_type
    @data = data
  end

  def to_s
    "data:#{content_type};base64,#{encoded_content}"
  end

  private

  attr_reader :content_type, :data

  def encoded_content
    @_encoded_content ||= Base64.encode64(data)
  end
end
