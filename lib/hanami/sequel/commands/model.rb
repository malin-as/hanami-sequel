require 'erb'

module Hanami
  module Sequel
    module CLI
      class Model < Hanami::CLI::Command
        argument :name, required: true, desc: 'Name of the model'

        def call(name:, **options)
          # db/migrations/date-create-table_name.rb

          source = CLI.template('model-migration')

          under_name = Utils::String.underscore(name)
          table_name = Utils::String.pluralize(under_name)

          now = Time.now.strftime('%Y%m%d%H%M%S')
          destination = File.join('./',
                                  CLI.config.migrations,
                                  "#{now}-create-#{table_name}.rb")

          b = ErBinding.new(table_name: table_name)
          content = ERB.new(File.read(source)).result(b.bind)

          File.write(destination, content)

          # lib/project_name/models/model_name.rb

          source = CLI.template('model-sequel')

          camel_name = Utils::String.classify(name)
          model_name = "#{camel_name}Model"

          model_path = File.join('./', CLI.lib_path, 'models')
          Dir.mkdir(model_path) unless Dir.exist?(model_path)

          destination = File.join(model_path, "#{under_name}_model.rb")

          b = ErBinding.new(model_name: model_name,
                            table_name: table_name)
          content = ERB.new(File.read(source)).result(b.bind)

          File.write(destination, content)
        end
      end
    end
  end
end

Hanami::CLI.register 'sequel model', Hanami::Sequel::CLI::Model
