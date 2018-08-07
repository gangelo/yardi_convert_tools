
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "yardi_convert_tools/version"

Gem::Specification.new do |spec|
  spec.name          = "yardi_convert_tools"
  spec.version       = YardiConvertTools::VERSION
  spec.authors       = ["gangelo"]
  spec.email         = ["web.gma@gmail.com"]

  spec.summary       = %q{Tools for converting a property to Yardi.}
  spec.description   = %q{A set of tools used to help in the process of converting a property to yardi.}
  spec.homepage      = "https://github.com/gangelo/yardi_convert_tools"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.8'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'aruba', '~> 0.14.1'
  spec.add_development_dependency 'colorize'
end
