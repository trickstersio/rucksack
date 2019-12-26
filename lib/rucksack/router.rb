module Rucksack
  class Router
    def self.routing
      @routing
    end

    def self.routing=(block)
      @routing = block
    end

    def configure(app)
      app.instance_eval(&self.class.routing)
    end
  end
end
