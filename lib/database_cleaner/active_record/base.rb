require 'database_cleaner/generic/base'
require 'active_record'
require 'erb'

module DatabaseCleaner
  module ActiveRecord

    def self.available_strategies
      %w[truncation transaction deletion]
    end

    module Base
      include ::DatabaseCleaner::Generic::Base

      def db=(model_class)
        @model_class = model_class
        @connection_class = nil
      end

      def db
        @model_class || super
      end

      def connection
        connection_class.connection
      end

      def create_connection_klass
        Class.new(::ActiveRecord::Base)
      end

      def connection_klass
        return ::ActiveRecord::Base unless connection_hash
        klass = create_connection_klass
        klass.send :establish_connection, connection_hash
        klass
      end

      private

      def connection_class
        @connection_class ||=  if @model_class
                                 @model_class.is_a?(String) ? Module.const_get(@model_class) : @model_class
                               else
                                 ::ActiveRecord::Base
                               end
      end
    end
  end
end
