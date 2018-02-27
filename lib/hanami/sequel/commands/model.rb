require 'erb'

module Hanami
  module Sequel
    module CLI
      class Model < Hanami::CLI::Command
        argument :name, required: true, desc: 'Name of the model'

        def call(name:, **options)
          source = CLI.template('model-migration')

          name = Utils::String.underscore(name)
          table_name = Utils::String.pluralize(name)

          now = Time.now.strftime('%Y%m%d%H%M%S')
          destination = File.join('./',
                                  CLI.config.migrations,
                                  "#{now}-#{table_name}.rb")

          b = ErBinding.new(table_name: table_name)

          content = ERB.new(File.read(source)).result(b.bind)

          File.write(destination, content)
        end
      end
    end
  end
end

Hanami::CLI.register 'sequel model', Hanami::Sequel::CLI::Model
