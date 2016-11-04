# frozen_string_literal: true

module GnresolverClient
  # Name Resolvers resource
  module NameResolvers
    PATH = "name_resolvers"

    class << self
      def resolve(names, opts = {})
        [names, opts]
      end
    end
  end
end
