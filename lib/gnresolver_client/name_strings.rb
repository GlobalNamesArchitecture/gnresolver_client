# frozen_string_literal: true

module GnresolverClient
  # Name String resource
  module NameStrings
    PATH = "name_strings"

    class << self
      def uuid(term, opts = {})
        path = PATH + "/" + URI.escape(term)
        params = { path: path, method: :get }.merge(opts)
        GnresolverClient::Engine.query(params)
      end

      def search(term, opts = {})
        params = { path: PATH, method: :get,
                   params: { search_term: term }.merge(opts) }
        GnresolverClient::Engine.query(params)
      end
    end
  end
end
