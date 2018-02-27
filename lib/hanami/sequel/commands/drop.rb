module Hanami
  module Sequel
    module CLI
      class Drop < Hanami::CLI::Command
        def call(**options)
          env = Hanami::Environment.new
          if env.environment == 'production'
            raise 'Command unavailable in the production environment.'
          end

          db_url = ENV.fetch('DATABASE_URL')
          db_conn, _, db_name = db_url.rpartition('/')

          require 'sequel'

          db = ::Sequel.connect("#{db_conn}/postgres",
                                loggers: Logger.new($stdout))
          db.run("DROP DATABASE IF EXISTS #{db_name}")
        end
      end
    end
  end
end

Hanami::CLI.register 'sequel drop', Hanami::Sequel::CLI::Drop
