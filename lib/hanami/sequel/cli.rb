require 'erb'

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
