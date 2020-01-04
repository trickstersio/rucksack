require "json"

require "sinatra"
require "sinatra/base"

require "zeitwerk"

zeitwerk = Zeitwerk::Loader.for_gem
zeitwerk.setup

module Rucksack
  class Error < StandardError; end

  def self.router(&block)
    router_class = Class.new(Rucksack::Router)
    router_class.routing = block
    router_class
  end
end

zeitwerk.eager_load
