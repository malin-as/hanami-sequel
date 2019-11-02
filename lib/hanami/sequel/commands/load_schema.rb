module Hanami
  module Sequel
    module CLI
      class LoadSchema < Hanami::CLI::Command
        def call(**options)
          Command.load_schema
        end
      end
    end

    module Command
      def self.load_schema
        env = Hanami::Environment.new
        if env.environment == 'production'
          raise 'Command unavailable in the production environment.'
        end

        db_url = ENV.fetch('DATABASE_URL')
        # db_conn, _, db_name = db_url.rpartition('/')

        schema_file_path = File.join(Hanami.root, 'db', 'schema.sql')

        if Hanami::Utils::Files.exist?(schema_file_path)
          schema_file = File.open(schema_file_path, 'rb')
          sql = schema_file.read
        else
          raise 'You must have a schema.sql file in db root directory'
        end

        require 'sequel'

        db = ::Sequel.connect(db_url, loggers: Logger.new($stdout))
        db.run(sql)
      end
    end
  end
end

Hanami::CLI.register 'sequel load-schema', Hanami::Sequel::CLI::LoadSchema
