require 'open-uri'
require 'base64'

class WebImageReaderService
  attr_reader :url

  def initialize(url)
    raise ArgumentError unless url

    @url = url
  end

  def image
    @image ||= open(url).read
  end

  def image_base64
    @image_base64 ||= Base64.encode64(image)
  end
end
