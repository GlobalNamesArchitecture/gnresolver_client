# frozen_string_literal: true

module GnresolverClient
  # Name Resolvers resource
  module NameResolvers
    PATH = "name_resolvers"

    class << self
      def search(method, term, opts = {})
        params = { path: PATH, method: method,
                   params: { names: term }.merge(opts) }
        GnresolverClient::Engine.query(params)
      end
    end
  end
end
