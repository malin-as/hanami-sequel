require 'fileutils'

module Hanami
  module Sequel
    module CLI
      def self.hanamirc
        @hanamirc ||= Hanamirc.new(Pathname.new('.'))
      end

      def self.lib_path
        @lib_path ||= "lib/#{hanamirc.options[:project]}"
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
        dirname = File.dirname(destination)
        Dir.mkdir_p(dirname) unless Dir.exist?(dirname)

        content = ERB.new(File.read(template))
                     .result(erbinding&.bind)
        File.write(destination, content)
      end
    end
  end
end

require_relative 'commands/create'
require_relative 'commands/migration'
require_relative 'commands/model'
