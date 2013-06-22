require 'listen'

module GHPreview
  class Watcher
    def self.watch(filepath)
      yield

      filename = File.basename(filepath)
      dirname  = File.dirname(File.expand_path(filepath))

      Listen.to(dirname, filter: /#{filename}$/) do |modified|
        yield
      end
    end
  end
end
