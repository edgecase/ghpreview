# encoding: UTF-8

require_relative '../lib/ghpreview/converter'

describe GHPreview::Converter do
  let(:converter) { GHPreview::Converter }

  it "converts markdown to HTML" do
    expect(converter.to_html('*Foo*')).to eql('<p><em>Foo</em></p>')
  end

  it 'includes anchor links in headings' do
    expect(converter.to_html('# Foo')).to eql("<h1>\n<a href=\"#foo\"></a>Foo</h1>")
  end

  it "passes through non-ASCII characters" do
    expect(converter.to_html('Baña')).to eql('<p>Baña</p>')
  end
end
