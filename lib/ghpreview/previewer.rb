require 'erb'
require 'listen'
require 'httpclient'
require_relative 'converter'

module GHPreview
  class Previewer
    HTML_FILEPATH            = '/tmp/ghpreview.html'
    RAW_TEMPLATE_FILEPATH    = "#{File.dirname(__FILE__)}/template.erb"
    STYLED_TEMPLATE_FILEPATH = "/tmp/ghpreview-template.erb"
    HOMEPAGE                 = 'https://github.com'
    TEMPLATE_CACHE_DURATION  = 60 * 60 * 24 * 7 # one week

    def initialize(md_filepath, options = {})
      @md_filepath = md_filepath
      @http        = HTTPClient.new
      generate_template_with_fingerprinted_stylesheet_links

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
      html = wrap_content_with_full_document(html)
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

    private

    def generate_template_with_fingerprinted_stylesheet_links
      if stale_template?(STYLED_TEMPLATE_FILEPATH)
        stylesheet_links = @http.get(HOMEPAGE).body.split("\n").select do |line|
          line =~ /https:.*github.*\.css/
        end.join

        raw_template = File.read(RAW_TEMPLATE_FILEPATH)
        styled_template = ERB.new(raw_template).result(binding)
        File.open(STYLED_TEMPLATE_FILEPATH, 'w') do |f|
          f.write(styled_template)
        end
      end
    end

    def stale_template?(filepath)
      return true unless File.exists?(filepath)
      File.mtime(filepath) < (Time.now - TEMPLATE_CACHE_DURATION)
    end

    def wrap_content_with_full_document(content)
      template = File.read(STYLED_TEMPLATE_FILEPATH)
      ERB.new(template).result(binding)
    end
  end
end
