module Rucksack
  class Response
    attr_accessor :status
    attr_accessor :headers
    attr_accessor :body

    def initialize(status, headers, body)
      @status = status
      @headers = headers
      @body = body

      if !body.nil?
        @headers[Rucksack::Headers::CONTENT_TYPE] = body.content_type
      end
    end

    def to_a
      [ status.to_i, headers.to_h, body.to_s ]
    end
  end
end
