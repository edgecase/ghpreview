require 'listen'
require_relative 'converter'
require_relative 'wrapper'
require_relative 'viewer'

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
      open

      filename = File.basename(@md_filepath)
      dirname  = File.dirname(File.expand_path(@md_filepath))

      Listen.to(dirname, filter: /#{filename}$/) do |modified|
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
