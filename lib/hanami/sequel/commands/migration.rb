require 'erb'

module Hanami
  module Sequel
    module CLI
      class Migration < Hanami::CLI::Command
        argument :name, required: true, desc: 'Name of the migration'

        def call(name:, **options)
          source = CLI.template('migration')

          now = Time.now.strftime('%Y%m%d%H%M%S')
          name = Utils::String.underscore(name)
          destination = File.join('./',
                                  CLI.config.migrations,
                                  "#{now}-#{name}.rb")

          content = ERB.new(File.read(source)).result

          File.write(destination, content)
        end
      end
    end
  end
end

Hanami::CLI.register 'sequel migration', Hanami::Sequel::CLI::Migration
