module Rucksack
  class Application
    include Rucksack::Enhancers::Callbacks

    self.available_callback_kinds = [ :before_request, :after_request ]

    def self.configure(klass = nil)
      if klass
        @configuration = klass.new
      end

      yield @configuration if block_given?

      @configuration
    end

    def self.configuration
      @configuration
    end

    def self.register_before_request_callback(&block)
      register_callback(:before_request, &block)
    end

    def self.register_after_request_callback(&block)
      register_callback(:after_request, &block)
    end

    def self.logger
      @configuration.logger
    end

    def self.default_content_types
      @configuration.default_content_types
    end

    def initialize
      @routes = []
    end

    def get(path, to, params: {}, content_types: self.class.default_content_types)
      @routes << Rucksack::Route.new(:get, path, to, params, content_types)
    end

    def post(path, to, params: {}, content_types: self.class.default_content_types)
      @routes << Rucksack::Route.new(:post, path, to, params, content_types)
    end

    def put(path, to, params: {}, content_types: self.class.default_content_types)
      @routes << Rucksack::Route.new(:put, path, to, params, content_types)
    end

    def patch(path, to, params: {}, content_types: self.class.default_content_types)
      @routes << Rucksack::Route.new(:patch, path, to, params, content_types)
    end

    def delete(path, to, params: {}, content_types: self.class.default_content_types)
      @routes << Rucksack::Route.new(:delete, path, to, params, content_types)
    end

    def configuration
      self.class.configuration
    end

    def logger
      self.class.logger
    end

    def router=(router)
      router.configure(self)
    end

    def rack_app
      application = self

      klass = Class.new(Rucksack::Base) do
        set :protection, except: :json_csrf

        configure :development, :test, :production do
          enable :logging
        end

        not_found do
          { message: "Not Found" }.to_json
        end
      end

      @routes.each do |route|
        logger.debug "Register #{route.verb} #{route.path} to be handled by #{route.endpoint.name}"

        klass.public_send(route.verb, route.path) do
          if !route.handle?(request)
            pass
          end

          begin
            application.execute_callbacks(:before_request, request)
            response = route.handle(request, params)
          ensure
            application.execute_callbacks(:after_request, request)
          end

          response
        end
      end

      klass
    end
  end
end
