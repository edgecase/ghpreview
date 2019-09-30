# frozen_string_literal: true

require 'erb'
require 'httpclient'

module GHPreview
  class Wrapper
    GITHUB_URL               = 'https://github.com'
    STYLED_TEMPLATE_FILEPATH = '/tmp/ghpreview-template.erb'
    TEMPLATE_CACHE_DURATION  = 60 * 60 * 24 * 7 # one week
    RAW_TEMPLATE_FILEPATH    = "#{File.dirname(__FILE__)}/template.erb"

    def self.generate_template_with_fingerprinted_stylesheet_links
      http = HTTPClient.new

      if stale_template?(STYLED_TEMPLATE_FILEPATH)
        stylesheet_links = http.get(GITHUB_URL).body.split("\n").select do |line|
          line =~ /https:.*github.*\.css/
        end.join

        raw_template = File.read(RAW_TEMPLATE_FILEPATH)
        styled_template = ERB.new(raw_template).result(binding)
        File.open(STYLED_TEMPLATE_FILEPATH, 'w') do |f|
          f.write(styled_template)
        end
      end
    end

    def self.wrap_html(content)
      template = File.read(STYLED_TEMPLATE_FILEPATH)
      ERB.new(template).result(binding)
    end

    private

    def self.stale_template?(filepath)
      return true unless File.exist?(filepath)

      File.mtime(filepath) < (Time.now - TEMPLATE_CACHE_DURATION)
    end
  end
end
