require 'net/http'
require 'open-uri'

module Github
  module Preview
    class Previewer
      API_HOST      = 'https://api.github.com'
      API_PATH      = '/markdown/raw'
      HOMEPAGE      = 'https://github.com'
      HTML_FILEPATH = '/tmp/github-preview.html'

      def initialize(md_filename)
        @md_filename = md_filename
      end

      def open
        html = markdown_to_html
        stylesheet_links = get_fingerprinted_stylesheet_links
        puts stylesheet_links
        html = wrap_html_with_style(html, stylesheet_links)
        File.open(HTML_FILEPATH, 'w') { |f| f << html }
        `open #{HTML_FILEPATH}`
      end

      private

      def markdown_to_html
        markdown     = File.read(@md_filename)
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

      def wrap_html_with_style(html, stylesheet_links)
        %Q{
          <html>
            <head>
              #{stylesheet_links.join}
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
end
