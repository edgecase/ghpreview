# frozen_string_literal: true

require_relative 'converter'
require_relative 'wrapper'
require_relative 'viewer'
require_relative 'watcher'

module GHPreview
  class Previewer
    def initialize(md_filepath, options = {})
      Wrapper.generate_template_with_fingerprinted_stylesheet_links

      @md_filepath = md_filepath
      @application = options[:application]

      options[:watch] ? listen : open
    end

    def listen
      puts "Previewing #{@md_filepath}. CTRL-C to stop."
      Watcher.watch @md_filepath do
        open
      end
    end

    def open
      html = Converter.to_html(File.read(@md_filepath))
      html = Wrapper.wrap_html(html)
      Viewer.view_html html, @application
    end
  end
end
