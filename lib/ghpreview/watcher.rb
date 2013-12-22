require 'listen'

module GHPreview
  class Watcher
    def self.watch(filepath)
      yield

      filename = File.basename(filepath)
      dirname  = File.dirname(File.expand_path(filepath))

      listener = Listen.to(dirname, filter: /#{filename}$/) do |modified|
        yield
      end
      listener.start

      Signal.trap('INT') do
        listener.stop
        exit
      end

      sleep
    end
  end
end
