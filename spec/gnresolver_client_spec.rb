require 'spec_helper'

describe GnresolverClient do
  it 'has a version number' do
    expect(GnresolverClient::VERSION).not_to match("\d+\.\d+\.\d+")
  end
end
