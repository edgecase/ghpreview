# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ghpreview/version'

Gem::Specification.new do |gem|
  gem.name          = 'ghpreview'
  gem.version       = GHPreview::VERSION
  gem.authors       = ['Adam McCrea']
  gem.email         = ['adam@adamlogic.com']
  gem.description   = 'Command line utility for previewing Markdown files with Github styling'
  gem.summary       = gem.description
  gem.homepage      = 'http://github.com/edgecase/ghpreview'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'bundler', '~> 1.17.2'
  gem.add_dependency 'commonmarker', '~> 0.16'
  gem.add_dependency 'escape_utils', '~> 1.0'
  gem.add_dependency 'gemoji', '~> 2.0'
  gem.add_dependency 'github-linguist', '~> 7.6'
  gem.add_dependency 'github-markdown', '~> 0.6'
  gem.add_dependency 'html-pipeline', '~> 2.12'
  gem.add_dependency 'httpclient', '~> 2.8'
  gem.add_dependency 'listen', '~> 3.1.5'
  gem.add_dependency 'rb-fsevent'
  gem.add_dependency 'rinku', '~> 1.7'
  gem.add_dependency 'rouge', '~> 3.1'
  gem.add_dependency 'sanitize', '~> 4.4.0'

  gem.add_development_dependency 'byebug'
end
