# frozen_string_literal: true

require "simplecov"

SimpleCov.start do
  add_filter "/spec/"
  add_filter "/bin/"
  add_filter "/coverage/"
end

require_relative "../lib/gnresolver_client"
require "support/helpers"
require "gnresolver_client"
