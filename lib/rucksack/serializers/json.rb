module Rucksack
  module Serializers
    class Json
      def initialize(body)
        @body = body
      end

      def content_type
        Rucksack::ContentTypes::JSON
      end

      def to_s
        @body.to_json
      end
    end
  end
end
