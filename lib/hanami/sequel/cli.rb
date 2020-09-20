require 'fileutils'

module Hanami
  module Sequel
    module CLI
      def self.hanamirc
        @hanamirc ||= Hanamirc.new(Pathname.new('.'))
      end

      def self.hanamirc_test
        hanamirc.options[:test] || hanamirc.default_options[:test]
      end

      def self.lib_path
        @lib_path ||= "lib/#{hanamirc.options[:project]}"
      end

      def self.models_path
        @models_path ||= File.join(lib_path, 'models')
      end

      def self.spec_path
        @spec_path ||= "spec/#{hanamirc.options[:project]}"
      end

      def self.config
        @config ||= Hanami::Sequel::Configuration.new
      end

      def self.template(name)
        File.join(File.dirname(__FILE__), 'templates', "#{name}.erb")
      end

      class ErBinding
        def initialize(**vars)
          @vars = vars
        end

        def bind
          @vars.each_with_object(binding) do |(k, v), b|
            b.local_variable_set(k.to_sym, v)
          end
        end
      end

      def self.generate(template, erbinding, destination)
        raise "File #{destination} already exists" if File.exist?(destination)

        dirname = File.dirname(destination)
        FileUtils.mkdir_p(dirname) unless Dir.exist?(dirname)

        content = ERB.new(File.read(template))
                     .result(erbinding&.bind)
        File.write(destination, content)

        log_file_handling('create', destination)
      end

      def self.log_file_handling(verb, file)
        puts "%12s  %s" % [verb, file]
      end
    end
  end
end

require_relative 'commands/create'
require_relative 'commands/load_schema'
require_relative 'commands/drop'
require_relative 'commands/install'
require_relative 'commands/migrate'
require_relative 'commands/migration'
require_relative 'commands/model'
