require_relative './region.rb'
require_relative './land_type.rb'

class Map

  attr_reader :width, :height, :grid_width
  attr_accessor :regions

  def initialize (width, height, grid_width)
    @regions = []
    @width   = width
    @height  = height
    @grid_width = grid_width

    MapDrawer.new(self).draw_map
  end
end
