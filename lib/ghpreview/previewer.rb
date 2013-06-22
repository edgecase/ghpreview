require 'listen'
require_relative 'converter'
require_relative 'wrapper'

module GHPreview
  class Previewer
    HTML_FILEPATH = '/tmp/ghpreview.html'

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
      File.open(HTML_FILEPATH, 'w') { |f| f << html }

      if RUBY_PLATFORM =~ /linux/
        command = if @application
                    `#{@application} #{HTML_FILEPATH} </dev/null &>/dev/null &`
                    else
                    `xdg-open #{HTML_FILEPATH}`
                  end
      else
        command = if @application
                    "open -a #{@application}"
                  else
                    'open'
                  end
        `#{command} #{HTML_FILEPATH}`
      end
    end

  end
end
