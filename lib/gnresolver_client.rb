require "ostruct"
require "rest_client"
require "gnresolver_client/version"
require "gnresolver_client/engine"

# Namespace module for the gem
module GnresolverClient
  GNR_URL = "http://gnresolver.globalnames.org/api/".freeze
  class << self
    def conf
      @conf || init_conf
    end

    private

    def init_conf
      url = ENV["GNR_URL"] || GNR_URL
      @conf = OpenStruct.new(url: url)
    end
  end
end
