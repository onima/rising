require 'nokogiri'

class Region
  attr_reader :map_width, :map_height
  attr_accessor :coordinates, :land_type, :has_tribe, :id, :player_defense

  def initialize(coordinates, width, height, id)
    @coordinates = coordinates
    @map_width = width
    @map_height = height
    @id = id
  end

  def has_external_border?
    has_west_border? ||
      has_north_border? ||
      has_south_border? ||
      has_east_border?
  end

  def external_borders
    cardinal_points = []
    cardinal_points.push("W") if has_west_border?
    cardinal_points.push("N") if has_north_border?
    cardinal_points.push("E") if has_east_border?
    cardinal_points.push("S") if has_south_border?
    cardinal_points
  end

  def to_svg(players)
    obj = Nokogiri::XML::Builder.new do
      polygon
    end
    root = obj.doc.root
    root['style'] = "fill:#{land_type.color};fill-opacity:0.7"
    players.each {|player| root['style'] = "fill:#{land_type.color};stroke:#{player.color};stroke-width:2.5px;fill-opacity:0.7" if player.occupied_regions.include?(self)}
    root['points'] = svg_coordinates
    root.to_xml
  end

  def svg_coordinates
    @coordinates.map{ |h| "#{h[:x]},#{h[:y]} " }.reduce("",:<<)
  end

  def is_not_a_sea?
    land_type.name != "sea"
  end

  def round_coordinates
    coordinates.map {|hash| {x: hash[:x].round, y: hash[:y].round}}
  end

  def neutral_defense_points
    has_tribe ? land_type.conquest_points + 1 : land_type.conquest_points
  end

  def occupied?(players)
     occupied = false
     players.each {|player| occupied = true  if player.occupied_regions.include?(self)}
     occupied
  end

  def text_name_coordinate_y
    @coordinates[2][:y] - ((@coordinates[2][:y] - @coordinates[4][:y]) / 2)
  end

  def text_id_coordinate_x
    @coordinates[2][:x] + (@coordinates[2][:x] - @coordinates[3][:x])
  end

  def text_id_coordinate_y
    @coordinates[0][:y] + ((@coordinates[1][:y] - @coordinates[0][:y]) / 2 )
  end

  private

  def has_west_border?
    @id <= @map_height
  end

  def has_east_border?
    @id > @map_width * @map_height - @map_height && @id <= @map_width * @map_height
  end

  def has_north_border?
    (@id - 1) % @map_height == 0
  end

  def has_south_border?
    (@id) % @map_height == 0
  end

end
