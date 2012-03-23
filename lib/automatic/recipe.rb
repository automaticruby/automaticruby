# Name::      Automatic::Recipe
# Author::    ainame
# Created::   Feb 18, 2012
# Updated::   Mar 12, 2012
# Copyright:: 774 Copyright (c) 2012
# License::   Licensed under the GNU GENERAL PUBLIC LICENSE, Version 3.0.

require 'hashie'
require 'yaml'

module Automatic
  class Recipe
    attr_reader :procedure

    def initialize(path = "")
      load_recipe(path)
    end

    def load_recipe(path)
      @procedure = Hashie::Mash.new(YAML.load(File.read(path)))
    end

    def each_plugin
      @procedure.plugins.each { |plugin|
        yield plugin
      }
    end
  end
end
