module Hanami
  module Sequel
    module CLI
      class Migrate < Hanami::CLI::Command
        argument :version,
                 required: false,
                 default: 'up',
                 desc: 'Version of the migration (number, offset, timestamp, "up" or "down"). Default: "up"'
        option :allow_missing, default: false, values: %w[true false], desc: 'Allow missing migration files (usefull when migrating from legacy databases)'

        def call(**options)
          Command.migrate(options)
        end
      end
    end

    module Command
      def self.migrate(**options)
        Hanami::Environment.new             # load DATABASE_URL

        args = {}

        if (v = options[:version])
          case
          when v == 'up' then;
          when v == 'down' then args[:target] = 0
          else args[:target] = Integer(v)
          end
        end

        if options[:allow_missing] == 'true'
          args[:allow_missing_migration_files] = true
        end

        require 'sequel'
        ::Sequel.extension :migration

        db = ::Sequel.connect(ENV.fetch('DATABASE_URL'),
                              loggers: Logger.new($stdout))

        ::Sequel::Migrator.run(db, CLI.config.migrations, **args)
      end
    end
  end
end

Hanami::CLI.register 'sequel migrate', Hanami::Sequel::CLI::Migrate
