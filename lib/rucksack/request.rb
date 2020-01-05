module Rucksack
  class Request
    attr_reader :rack_request
    attr_reader :params

    def initialize(rack_request, params)
      @rack_request = rack_request
      @params = params.map { |k, v| [ k.to_sym, v ] }.to_h
    end

    def json
      return {} if !rack_request.content_type == Rucksack::ContentTypes::JSON

      @json ||= body do |data|
        JSON.parse(data, symbolize_names: true)
      rescue JSON::ParserError
        {}
      end
    end

    def env
      rack_request.env
    end

    def body
      rack_request.body.rewind # in case someone already read it
      result = rack_request.body.read
      if block_given?
        result = yield(result)
      end
      rack_request.body.rewind # to allow others read it if they want
      result
    end
  end
end
