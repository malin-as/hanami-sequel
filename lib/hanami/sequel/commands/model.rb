require 'erb'

module Hanami
  module Sequel
    module CLI
      class Model < Hanami::CLI::Command
        argument :name, required: true, desc: 'Name of the model'

        def call(name:, **options)
          under_name = Utils::String.underscore(name)
          table_name = Utils::String.pluralize(under_name)

          camel_name = Utils::String.classify(name)
          model_name = "#{camel_name}Model"

          # db/migrations/date-create-table_name.rb

          now = Time.now.strftime('%Y%m%d%H%M%S')
          destination = File.join(CLI.config.migrations,
                                  "#{now}_create_#{table_name}.rb")

          b = ErBinding.new(table_name: table_name)

          CLI.generate(CLI.template('model-migration'), b, destination)

          # lib/project_name/models/model_name.rb

          destination = File.join(CLI.lib_path,
                                  'models',
                                  "/#{under_name}_model.rb")

          b = ErBinding.new(model_name: model_name,
                            table_name: table_name)

          CLI.generate(CLI.template('model-sequel'), b, destination)
        end
      end
    end
  end
end

Hanami::CLI.register 'sequel model', Hanami::Sequel::CLI::Model
