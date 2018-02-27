module Hanami
  module Sequel
    module CLI
      class Migrate < Hanami::CLI::Command
        argument :version,
                 required: false,
                 default: 'up',
                 desc: 'Version of the migration (number, offset, timestamp, "up" or "down"). Default: "up"'

        def call(**options)
          Hanami::Environment.new             # load DATABASE_URL

          args = {}

          if (v = options[:version])
            case
            when v == 'up' then;
            when v == 'down' then args[:target] = 0
            when v.start_with?('+') then args[:relative] = v.to_i
            when v.start_with?('-') then args[:relative] = v.to_i
            else args[:target] = v.to_i
            end
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
end

Hanami::CLI.register 'sequel migrate', Hanami::Sequel::CLI::Migrate
