require 'nokogiri'

class Region < Struct.new(:coordinates, :map_width, :map_height, :id)
  attr_accessor :land_type, :has_tribe, :player_defense

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
    fill_region_with_color(root)
    players.each do |player|
      if player.occupied_regions.include?(self)
        draw_stroke(root, player)
      end
    end
    root['points'] = svg_coordinates
    root.to_xml
  end

  def svg_coordinates
    svg_coordinates = coordinates.map do |h|
      "#{h.fetch("x")},#{h.fetch("y")} "
    end
    svg_coordinates.reduce("",:<<)
  end

  def is_not_a_sea?
    land_type.name != "sea"
  end

  def round_coordinates
    coordinates.map do |hash|
      {"x"=> hash.fetch("x").round, "y"=>hash.fetch("y").round}
    end
  end

  def neutral_defense_points
    has_tribe ? land_type.conquest_points + 1 : land_type.conquest_points
  end

  def occupied?(players)
     players.any? { |player| player.occupied_regions.include?(self) }
  end

  def adjust_x_text
    case land_type.name.length
    when 0..4
      coordinates[2]["x"] + 15
    when 6
      coordinates[2]["x"] + 5
    when 8
      coordinates[2]["x"] - 5
    else
      coordinates[2]["x"]
    end
  end

  def adjust_y_text
    coordinates[2]["y"] - ((coordinates[2]["y"] - coordinates[4]["y"]) / 2)
  end

  def adjust_x_id
    coord = coordinates[2]["x"] + (coordinates[2]["x"] - coordinates[3]["x"])
    if id > 9
      coord - 10
    else
      coord - 5
    end
  end

  def adjust_y_id
    coordinates[0]["y"] + ((coordinates[1]["y"] - coordinates[0]["y"]) / 2 )
  end

  def can_be_attacked?(player)
    player.can_attack_region?(self)
  end

  private

  def has_west_border?
    id <= map_height
  end

  def has_east_border?
    id > map_width * map_height - map_height && id <= map_width * map_height
  end

  def has_north_border?
    (id - 1) % map_height == 0
  end

  def has_south_border?
    (id) % map_height == 0
  end

  def fill_region_with_color(root)
    root['style'] = "fill:#{land_type.color};fill-opacity:0.7"
  end

  def draw_stroke(root, player)
    root['style'] = "fill:#{land_type.color};
    stroke:#{player.color};
    stroke-width:2.5px;fill-opacity:0.7"
  end

end
