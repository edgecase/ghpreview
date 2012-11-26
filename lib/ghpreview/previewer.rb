require 'net/http'
require 'open-uri'
require 'listen'

module GHPreview
  class Previewer
    API_HOST      = 'https://api.github.com'
    API_PATH      = '/markdown/raw'
    HOMEPAGE      = 'https://github.com'
    HTML_FILEPATH = '/tmp/ghpreview.html'

    def initialize(md_filepath)
      @md_filepath = md_filepath
      @md_filename = md_filepath.split('/').last
      @md_filedir  = md_filepath.split('/').unshift('.').uniq[0..-2].join('/')
      @stylesheet_links = get_fingerprinted_stylesheet_links
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
      markdown     = File.read(@md_filepath)
      uri          = URI.parse(API_HOST)
      http         = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request      = Net::HTTP::Post.new(API_PATH)
      request.add_field('Content-Type', 'text/plain')
      request.body = markdown
      response     = http.request(request)
      response.body
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
