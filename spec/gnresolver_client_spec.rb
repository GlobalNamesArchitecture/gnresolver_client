# frozen_string_literal: true

describe GnresolverClient do
  describe ".version" do
    it "has a version number as a constant" do
      expect(subject::VERSION).to match(/\d+\.\d+\.\d+/)
    end

    it "exposees version as a method" do
      expect(subject.version).to eq subject::VERSION
    end
  end
end
