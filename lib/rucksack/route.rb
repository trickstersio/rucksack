module Rucksack
  class Route
    attr_reader :verb
    attr_reader :path
    attr_reader :endpoint
    attr_reader :params
    attr_reader :content_types

    def initialize(verb, path, endpoint, params, content_types)
      @verb = verb
      @path = path
      @endpoint = endpoint
      @params = params
      @content_types = content_types
    end

    def handle(request, params)
      endpoint_instance = endpoint.new(Rucksack::Request.new(request, @params.merge(params)))

      begin
        endpoint_instance.execute_callbacks(:before)
        endpoint_instance.handle
        endpoint_instance.execute_callbacks(:after)
      rescue RuntimeError, StandardError => e
        endpoint_instance.execute_callbacks(:rescue, e)
      end

      endpoint_instance.response.to_a
    end

    def handle?(request)
      @content_types.any? { |content_type| request.accept?(content_type) }
    end
  end
end
