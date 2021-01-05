module Rucksack
   class Configuration
    DEFAULT_CONTENT_TYPES = [ Rucksack::ContentTypes::JSON ]
    APP_ROOT_PATH = Pathname.new(File.expand_path("../..", __dir__))

    attr_accessor :logger
    attr_accessor :default_content_types

    def initialize
      ActiveRecord::Migration.check_pending!

      @default_content_types = Rucksack::Configuration::DEFAULT_CONTENT_TYPES
    end

    def database_migrations_path
      relative_to_root('db/migrations')
    end

    def database_schema_path
      relative_to_root('db/schema.rb')
    end

    private def relative_to_root(path)
      Pathname.new(File.expand_path(path, APP_ROOT_PATH))
    end
  end
end
