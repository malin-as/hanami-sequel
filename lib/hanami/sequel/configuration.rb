module Hanami
  module Sequel
    class Configuration
      def initialize
        @migrations = 'db/migrations'
      end

      attr_reader :migrations
    end
  end
end
