# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ghpreview/version'

Gem::Specification.new do |gem|
  gem.name          = "ghpreview"
  gem.version       = GHPreview::VERSION
  gem.authors       = ["Adam McCrea"]
  gem.email         = ["adam@adamlogic.com"]
  gem.description   = %q{Command line utility for previewing Markdown files with Github styling}
  gem.summary       = gem.description
  gem.homepage      = "http://github.com/newcontext/ghpreview"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'listen'
  gem.add_dependency 'rb-fsevent'
  gem.add_dependency 'html-pipeline', '0.0.6'
  gem.add_dependency 'httpclient'
  gem.add_dependency 'github-linguist', '2.1'
end
