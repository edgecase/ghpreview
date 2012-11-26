require 'httpclient'
require 'listen'

module GHPreview
  class Previewer
    API_URI       = 'https://api.github.com/markdown/raw'
    HOMEPAGE      = 'https://github.com'
    HTML_FILEPATH = '/tmp/ghpreview.html'

    def initialize(md_filepath, options = {})
      @md_filepath = md_filepath
      @md_filename = md_filepath.split('/').last
      @md_filedir  = md_filepath.split('/').unshift('.').uniq[0..-2].join('/')
      @stylesheet_links = get_fingerprinted_stylesheet_links

      options[:watch] ? listen : open
    end

    def listen
      puts "Previewing #{@md_filepath}. CTRL-C to stop."
      open
      Listen.to(@md_filedir, filter: /#{@md_filename}$/) do |modified|
        open
      end
    end

    def open
      html = markdown_to_html
      html = wrap_html_with_style(html)
      File.open(HTML_FILEPATH, 'w') { |f| f << html }
      `open #{HTML_FILEPATH}`
    end

    private

    def markdown_to_html
      markdown = File.read(@md_filepath)
      client   = HTTPClient.new
      message  = client.post API_URI, body: markdown, header: {'Content-Type' => 'text/plain'}
      message.body
    end

    def get_fingerprinted_stylesheet_links
      uri = URI.parse(HOMEPAGE)
      uri.read.split("\n").select do |line|
        line =~ /https:.*github.*\.css/
      end
    end

    def wrap_html_with_style(html)
      %Q{
        <html>
          <head>
            #{@stylesheet_links.join}
            <style>
              body { padding: 30px 0; }
              #readme { width: 914px; margin: 0 auto; }
            </style>
          </head>
          <body>
            <div id="readme">
              <article class="markdown-body">
                #{html}
              </article>
            </div>
          </body>
        </html>
      }
    end
  end
end
