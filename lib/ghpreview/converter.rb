require 'html/pipeline'

module GHPreview
  class Converter
    def self.to_html(markdown)
      context = {
        asset_root: "http://assets.github.com/images/icons/",
        gfm: false
      }

      pipeline = HTML::Pipeline.new([
        HTML::Pipeline::MarkdownFilter,
        HTML::Pipeline::TableOfContentsFilter,
        HTML::Pipeline::SanitizationFilter,
        HTML::Pipeline::ImageMaxWidthFilter,
        HTML::Pipeline::HttpsFilter,
        HTML::Pipeline::MentionFilter,
        HTML::Pipeline::EmojiFilter,
        HTML::Pipeline::SyntaxHighlightFilter
      ], context)
      result = pipeline.call(markdown)[:output].to_s
    end
  end
end
