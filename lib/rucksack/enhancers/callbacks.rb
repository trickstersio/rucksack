module Rucksack
  module Enhancers
    module Callbacks
      class InvalidKindError < StandardError; end

      def self.included(base)
        base.extend ClassMethods
      end

      def execute_callbacks(kind, *args)
        self.class.execute_callbacks(self, kind, args)
      end

      module ClassMethods
        def available_callback_kinds
          @available_callback_kinds ||=
            if self.superclass.respond_to?(:available_callback_kinds)
              self.superclass.available_callback_kinds
            else
              []
            end
        end

        def available_callback_kinds=(kinds)
          superclass_available_callback_kinds =
            if self.superclass.respond_to?(:available_callback_kinds)
              self.superclass.available_callback_kinds
            else
              []
            end

          @available_callback_kinds = superclass_available_callback_kinds + kinds
        end

        def execute_callbacks(obj, kind, args)
          unless available_callback_kinds.include?(kind)
            raise InvalidKindError, "Received invalid callback kind: #{kind}"
          end

          registered_callbacks[kind].reverse.each do |callback|
            obj.instance_exec(*args, &callback)
          end
        end

        def register_callback(kind, &block)
          unless available_callback_kinds.include?(kind)
            raise Enhancers::Callbacks::InvalidKindError, "Received invalid callback kind: #{kind}"
          end

          registered_callbacks[kind] << block if !block.nil?
        end

        def registered_callbacks
          @registered_callbacks ||= begin
            hash = {}

            available_callback_kinds.each do |kind|
              hash[kind] = []
              if self.superclass.respond_to?(:registered_callbacks)
                superclass.registered_callbacks[kind].each { |cb| hash[kind] << cb }
              end
            end

            hash
          end

          Hash[@registered_callbacks]
        end
      end
    end
  end
end
