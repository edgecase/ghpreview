# encoding: UTF-8

require_relative '../lib/ghpreview/converter'

describe GHPreview::Converter do
  let(:converter) { GHPreview::Converter }

  it "converts markdown to HTML" do
    expect(converter.to_html('*Foo*')).to eql('<p><em>Foo</em></p>')
  end

  it 'includes anchor links in headings' do
    expect(converter.to_html('# Foo')).to eql("<h1>\n<a id=\"foo\" class=\"anchor\" href=\"#foo\" aria-hidden=\"true\"><span aria-hidden=\"true\" class=\"octicon octicon-link\"></span></a>Foo</h1>")
  end

  it "passes through non-ASCII characters" do
    expect(converter.to_html('Baña')).to eql('<p>Baña</p>')
  end
end
