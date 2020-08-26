# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rurses/version'

Gem::Specification.new do |spec|
  spec.name          = "rurses"
  spec.version       = Rurses::VERSION
  spec.authors       = ["James Edward Gray II"]
  spec.email         = ["james@graysoftinc.com"]

  spec.summary       = %q{A more Ruby style wrapper over ncurses.}
  spec.description   = %q{This library aims to make working with ncurses code feel more natural to Rubyists.  Full Ruby objects wrap C pointers, blocks are used where they make sense, and the library has some intelligent default behavior built in.}
  spec.homepage      = "https://github.com/JEG2/rurses"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "ffi-ncurses", "~> 0.4.0"

  spec.add_development_dependency "bundler",   "~> 2.1"
  spec.add_development_dependency "rake",      "~> 13.0.1"
  spec.add_development_dependency "rspec",     "~> 3.9.0"
  spec.add_development_dependency "simplecov", "~> 0.19.0"
end
