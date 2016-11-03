# frozen_string_literal: true

describe GnresolverClient::Engine do
  describe "#connected?" do
    it "checks connection to gnresolver" do
      expect(subject.connected?).to be true
    end
  end
end
