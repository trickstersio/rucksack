lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "rucksack/version"

Gem::Specification.new do |spec|
  spec.name          = "rucksack"
  spec.version       = Rucksack::VERSION
  spec.authors       = ["Sergey Tsvetkov"]
  spec.email         = ["sergey.a.tsvetkov@gmail.com"]

  spec.summary       = "Toolchain for writing fast and reliable web services using Ruby"
  spec.description   = "This gem contains all the stuff I would like to take with me into my next journey with Ruby."
  spec.homepage      = "https://github.com/trickstersio/rucksack"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = "https://github.com/trickstersio/rucksack"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/trickstersio/rucksack"
  spec.metadata["changelog_uri"] = "https://github.com/trickstersio/rucksack/CHANGELOG.md"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "rack", ">= 2.1.4"
  spec.add_dependency "zeitwerk", "~> 2.2"
  spec.add_dependency "sinatra", "~> 2.0"
  spec.add_dependency "activerecord", "~> 6.0.3"
  spec.add_dependency "activesupport", "~> 6.0.3"
end
