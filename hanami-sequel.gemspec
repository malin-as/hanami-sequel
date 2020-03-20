
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hanami/sequel/version"

Gem::Specification.new do |spec|
  spec.name          = "hanami-sequel"
  spec.version       = Hanami::Sequel::VERSION
  spec.authors       = ["Malina Sulca"]
  spec.email         = ["malina.sulca@gmail.com"]

  spec.summary       = %q{Integration of Sequel into Hanami.}
  spec.description   = %q{Integrates Sequel into Hanami by providing database commands and generating model files.}
  spec.homepage      = "https://github.com/malin-as/hanami-sequel.git"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "sequel", "~> 5.0"
  spec.add_dependency "hanami", "~> 1.1.0"
end
