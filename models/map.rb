require 'models/region.rb'
require 'models/land_type.rb'

class Map

  attr_reader :width, :height, :grid_width
  attr_accessor :regions

  def initialize (regions, width, height, grid_width)
    @regions = regions
    @width   = width
    @height  = height
    @grid_width = grid_width
  end
end
