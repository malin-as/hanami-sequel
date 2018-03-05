module Hanami
  module Sequel
    module CLI
      class Install < Hanami::CLI::Command
        def call(**options)
          Command.drop
          Command.create
          Command.migrate
          Command.seed
        end
      end
    end
  end
end

Hanami::CLI.register 'sequel install', Hanami::Sequel::CLI::Install
