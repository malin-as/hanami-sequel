require "hanami/sequel/configuration"

if defined?(Hanami::CLI)
  require "hanami/sequel/cli"
else
  require "hanami/sequel/model"
end

require "hanami/sequel/version"
