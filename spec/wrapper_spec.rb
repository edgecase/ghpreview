# frozen_string_literal: true

require_relative '../lib/ghpreview/wrapper'

describe GHPreview::Wrapper do
  let(:wrapper) { GHPreview::Wrapper }

  it 'wraps an HTML fragment in a full document' do
    fragment = '<h1>foo</h1>'
    expect(wrapper.wrap_html(fragment)).to include('<html>')
  end

  it 'passes through non-ASCII chars' do
    expect(wrapper.wrap_html('<h1>Baña</h1>')).to include('Baña')
  end

  it 'specifies the charset' do
    expect(wrapper.wrap_html('# foo')).to include("charset='utf-8'")
  end
end
