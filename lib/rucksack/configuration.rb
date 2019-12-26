module Rucksack
   class Configuration
    DEFAULT_CONTENT_TYPES = [ Rucksack::ContentTypes::JSON ]

    attr_accessor :logger
    attr_accessor :default_content_types

    def initialize
      @default_content_types = Rucksack::Configuration::DEFAULT_CONTENT_TYPES
    end
  end
end
