class MapDrawer

  REGION_TRIBE_RATIO = 4

  attr_reader :map, :radius, :x_base_offset, :hexagon_semi_vertical_height, :y_base_offset, :y_base_offset_lower

  def create_new_map(width, height, grid_width)
    @map = Map.new([], width, height, grid_width)
    @radius  = @map.grid_width / (@map.width * 1.5)
    @x_base_offset = 55
    @hexagon_semi_vertical_height = Math.sqrt(3) * @radius/2
    @y_base_offset = 55
    @y_base_offset_lower = @y_base_offset + @hexagon_semi_vertical_height
    draw_map
    @map
  end

  def land_types
    GameState::LAND_TYPES
  end

  def regions
    @map.regions
  end

  def draw_map
    draw_hexagons
    assign_lands
    assign_tribes
  end

  def draw_hexagons
    @map.width.times do |i|
      y_offset = i.even? ? @y_base_offset : @y_base_offset_lower
      draw_hexagon_col(1.5 * i * @radius, @x_base_offset, y_offset, i)
    end
  end

  def assign_lands
    [regions.first, regions.last, regions[middle_region]].each do |region|
      region.land_type = sea_land_type
    end

    regions_without_sea.each do |region|
      region.land_type = land_types_without_sea.sample
    end
  end

  def assign_tribes
    number_of_tribes = (regions_without_sea.length) / REGION_TRIBE_RATIO
    regions_occupied_by_tribes = regions_without_sea.sample(number_of_tribes)
    regions_occupied_by_tribes.each {|region_occupied| region_occupied.has_tribe = true}
  end

  def draw_hexagon_col(x, x_offset, y_offset, width_index)
    @map.height.times do |height_index|
      y = height_index * @radius * Math.sqrt(3)
      coordinates = find_hexagon_coordinates(x + x_offset, y + y_offset, @radius)
      create_region(coordinates, width_index, height_index)
    end
  end

  def create_region(coordinates, width_index, height_index)
    regions << Region.new(coordinates, @map.width, @map.height, height_index + 1 + @map.height * width_index)
  end

  def find_hexagon_coordinates(x_centre, y_centre, radius)
    6.times.map do |n|
      {
        x: radius * Math.cos(2*Math::PI*n/6) + x_centre,
        y: radius * Math.sin(2*Math::PI*n/6) + y_centre
      }
    end
  end

  def regions_without_sea
   regions.map.with_index { |region, i| region if region_is_not_sea?(i) }.compact
  end

  private

  def region_is_not_sea?(index)
    index != 0 &&  index != middle_region && index != (regions.length - 1)
  end

  def sea_land_type
    land_types.find{|land_type| land_type.name == 'sea'}
  end


  def land_types_without_sea
    land_types.reject {|land_type| land_type.name == 'sea'}
  end

  def middle_region
    (regions.length) / 2
  end
end
