require 'erb'
require 'html/pipeline'
require 'listen'
require 'httpclient'

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
      html = markdown_to_html
      html = wrap_content_with_full_document(html)
      File.open(HTML_FILEPATH, 'w') { |f| f << html }

      if RUBY_PLATFORM =~ /linux/
        command = 'xdg-open'
      else
        command = @application ? "open -a #{@application}" : 'open'
      end
      `#{command} #{HTML_FILEPATH}`
    end

    private

    def markdown_to_html
      markdown = File.read(@md_filepath)

      context = {
        asset_root: "http://assets.github.com/images/icons/",
        gfm: false
      }

      pipeline = HTML::Pipeline.new([
        HTML::Pipeline::MarkdownFilter,
        HTML::Pipeline::SanitizationFilter,
        HTML::Pipeline::ImageMaxWidthFilter,
        HTML::Pipeline::HttpsFilter,
        HTML::Pipeline::MentionFilter,
        HTML::Pipeline::EmojiFilter,
        HTML::Pipeline::SyntaxHighlightFilter
      ], context)
      result = pipeline.call(markdown)[:output].to_s
    end

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
