# -*- ruby -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'typographic-unit/version'

Gem::Specification.new do |gem|
  gem.name          = "typographic-unit"
  gem.version       = TypographicUnit::VERSION
  gem.authors       = ["Keita Yamaguchi"]
  gem.email         = ["keita.yamaguchi@gmail.com"]
  gem.description   = %q{typographic-unit is a Ruby library for converting between typographic units according to TeX.}
  gem.summary       = %q{converter between typographic units}
  gem.homepage      = "https://github.com/keita/typographic-unit"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_development_dependency "bacon"
end
