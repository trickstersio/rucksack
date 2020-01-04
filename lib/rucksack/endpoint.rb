module Rucksack
  class Endpoint
    class Halt < StandardError; end

    include Rucksack::Enhancers::Callbacks

    self.available_callback_kinds = [ :before, :after, :rescue ]

    def self.register_rescue_callback(*exception_classes, &block)
      register_callback(:rescue) do |e|
        if exception_classes.empty? || exception_classes.any? { |exception_class| e.is_a?(exception_class) }
          self.instance_exec(e, &block)
        end
      end
    end

    def self.register_before_callback(&block)
      register_callback(:before, &block)
    end

    def self.register_after_callback(&block)
      register_callback(:after, &block)
    end

    register_rescue_callback do |e|
      # This callback lives in the end of the chain and throws
      # an error up if it was not rescued by any of previous
      # callbacks
      raise e
    end

    register_rescue_callback Halt do |e|
      # This callback swallows Halt, so it'll not be raised up
      # from the endpoint
    end

    attr_reader :request
    attr_reader :response

    def initialize(request)
      @request = request
      @response = Rucksack::Response.new(501, nil, nil)
    end

    def halt!(status: 500, headers: {}, body: nil)
      render(status: status, headers: headers, body: body)
      raise Rucksack::Endpoint::Halt
    end

    def json(body)
      Rucksack::Serializers::Json.new(body)
    end

    def render(status: 200, headers: {}, body: nil)
      @response = Rucksack::Response.new(status, headers, body)
    end

    def redirect_to(location)
      render status: 302, headers: { Rucksack::Headers::LOCATION => location }
    end
  end
end
