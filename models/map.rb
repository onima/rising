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


#----------------
#
#map_hsh = session[:game_master][:map]
#
#map =
#  if map_hsh
#    bob.deserialize_map(map_hsh)
#  else
#    MapDrawer.new.create_map
#  end
