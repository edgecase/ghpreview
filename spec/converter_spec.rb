# encoding: UTF-8

require_relative '../lib/ghpreview/converter'

describe GHPreview::Converter do
  let(:converter) { GHPreview::Converter }

  it "converts markdown to HTML" do
    expect(converter.to_html('# Foo')).to eql('<h1>Foo</h1>')
  end

  it "passes through non-ASCII characters" do
    expect(converter.to_html('# Baña')).to eql('<h1>Baña</h1>')
  end
end
