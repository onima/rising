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
    draw_map(@map)
    @map
  end

  def land_types
    GameState::LAND_TYPES
  end

  def draw_map(map)
    draw_hexagons(map)
    assign_lands(map)
    assign_tribes(map)
  end

  def draw_hexagons(map)
    map.width.times do |i|
      y_offset = i.even? ? @y_base_offset : @y_base_offset_lower
      draw_hexagon_col(map, 1.5 * i * @radius, @x_base_offset, y_offset, i)
    end
  end

  def assign_lands(map)
    [map.regions.first, map.regions.last, map.regions[middle_region(map)]].each do |region|
      region.land_type = sea_land_type
    end
    regions_without_sea(map).each do |region|
      region.land_type = land_types_without_sea.sample
    end
  end

  def assign_tribes(map)
    number_of_tribes = (regions_without_sea(map).length) / REGION_TRIBE_RATIO
    regions_occupied_by_tribes = regions_without_sea(map).sample(number_of_tribes)
    regions_occupied_by_tribes.each do |region_occupied|
      region_occupied.has_tribe = true
    end
  end

  def draw_hexagon_col(map, x, x_offset, y_offset, width_index)
    map.height.times do |height_index|
      y = height_index * @radius * Math.sqrt(3)
      coordinates = find_hexagon_coordinates(
        x + x_offset,
        y + y_offset,
        @radius
      )
      create_region(map, coordinates, width_index, height_index)
    end
  end

  def create_region(map, coordinates, width_index, height_index)
    map.regions << Region.new(
      coordinates,
      map.width,
      map.height,
      height_index + 1 + map.height * width_index
    )
  end

  def find_hexagon_coordinates(x_centre, y_centre, radius)
    6.times.map do |n|
      {
        "x" => radius * Math.cos(2*Math::PI*n/6) + x_centre,
        "y" => radius * Math.sin(2*Math::PI*n/6) + y_centre
      }
    end
  end

  def regions_without_sea(map)
   regions_without_sea = map.regions.map.with_index do |region, i|
     region if region_is_not_sea?(map, i)
   end
     regions_without_sea.compact
  end

  private

  def region_is_not_sea?(map,index)
    index != 0 &&  index != middle_region(map) && index != (map.regions.length - 1)
  end

  def sea_land_type
    land_types.find { |land_type| land_type.name == 'sea' }
  end

  def land_types_without_sea
    land_types.reject { |land_type| land_type.name == 'sea' }
  end

  def middle_region(map)
    (map.regions.length) / 2
  end
end
