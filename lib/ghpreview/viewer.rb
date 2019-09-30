# frozen_string_literal: true

module GHPreview
  class Viewer
    HTML_FILEPATH = '/tmp/ghpreview.html'

    def self.view_html(html, application = nil)
      File.open(HTML_FILEPATH, 'w') { |f| f << html }

      if RUBY_PLATFORM =~ /linux/
        command = if application
                    `#{application} #{HTML_FILEPATH} </dev/null &>/dev/null &`
                  else
                    `xdg-open #{HTML_FILEPATH}`
                  end
      else
        command = if application
                    "open -a #{application}"
                  else
                    'open'
                  end
        `#{command} #{HTML_FILEPATH}`
      end
    end
  end
end
