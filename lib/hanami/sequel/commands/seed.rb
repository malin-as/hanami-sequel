module Hanami
  module Sequel
    module CLI
      class Seed < Hanami::CLI::Command
        def call(**options)
          Command.seed(options)
        end
      end
    end

    module Command
      def self.seed(**options)
        Hanami::Environment.new             # load DATABASE_URL

        require 'sequel'

        log = Logger.new($stdout)
        db = ::Sequel.connect(ENV.fetch('DATABASE_URL'),
                              loggers: log)
        ::Sequel::Model.db = db

        path = File.join('.', CLI.models_path, '*_model.rb')
        log.level = Logger::WARN
        Dir[path].each { |m| require m }
        log.level = Logger::INFO

        db.transaction do
          s = Hanami::Sequel::Seed
          s.methods(false).each { |m| s.send(m) }
        end
      end
    end

  end
end

Hanami::CLI.register 'sequel seed', Hanami::Sequel::CLI::Seed
