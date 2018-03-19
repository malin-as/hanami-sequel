require 'erb'
require 'fileutils'

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

          b = ErBinding.new(model_name: model_name,
                            table_name: table_name)

          # db/migrations/date-create-table_name.rb

          now = Time.now.strftime('%Y%m%d%H%M%S')
          destination = File.join(CLI.config.migrations,
                                  "#{now}_create_#{table_name}.rb")

          CLI.generate(CLI.template('model-migration'), b, destination)

          # lib/project_name/models/model_name.rb

          destination = File.join(CLI.lib_path,
                                  'models',
                                  "/#{under_name}_model.rb")

          CLI.generate(CLI.template('model-sequel'), b, destination)

          # spec/project_name/models/model_name_spec.rb

          destination = File.join(CLI.spec_path,
                                  'models',
                                  "/#{under_name}_model_spec.rb")

          model_spec = "model-spec-#{CLI.hanamirc_test}"
          CLI.generate(CLI.template(model_spec), b, destination)

          # spec/model_helpers.rb

          dest_helper = 'spec/models_helper.rb'

          unless File.exist?(dest_helper)
            model_helper = "models-helper-#{CLI.hanamirc_test}"
            CLI.generate(CLI.template(model_helper), nil, dest_helper)
          end
        end
      end
    end
  end
end

Hanami::CLI.register 'sequel model', Hanami::Sequel::CLI::Model
