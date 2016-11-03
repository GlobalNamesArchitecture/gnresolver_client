# frozen_string_literal: true

describe GnresolverClient::Searcher do
  describe ".search" do
    it "searches by genus name" do
      expect(subject.search("gen:Homo")).to be nil
    end
  end
end
