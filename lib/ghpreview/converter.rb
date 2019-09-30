# frozen_string_literal: true

require 'html/pipeline'

module GHPreview
  class Converter
    def self.to_html(markdown)
      context = {
        asset_root: 'https://github.githubassets.com/images/icons/',
        base_url: 'https://github.githubassets.com/images/icons/',
        gfm: false
      }

      pipeline = HTML::Pipeline.new([
                                      HTML::Pipeline::MarkdownFilter,
                                      HTML::Pipeline::SanitizationFilter,
                                      HTML::Pipeline::ImageMaxWidthFilter,
                                      HTML::Pipeline::TableOfContentsFilter,
                                      HTML::Pipeline::HttpsFilter,
                                      HTML::Pipeline::AutolinkFilter,
                                      HTML::Pipeline::MentionFilter,
                                      HTML::Pipeline::EmojiFilter,
                                      HTML::Pipeline::SyntaxHighlightFilter
                                    ], context)

      pipeline.call(markdown)[:output].to_s
    end
  end
end
