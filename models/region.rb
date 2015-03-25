require 'nokogiri'

class Region < Struct.new(:id)
  attr_accessor :land_type, :has_tribe, :player_defense, :columns, :rows

  def has_external_border?
      has_west_border? ||
      has_north_border? ||
      has_south_border? ||
      has_east_border?
  end

  def retrieve_columns_and_rows_from_map(columns,rows)
    @columns = columns
    @rows = rows
  end

  def external_borders
    cardinal_points = []
    cardinal_points.push("W") if has_west_border?
    cardinal_points.push("N") if has_north_border?
    cardinal_points.push("E") if has_east_border?
    cardinal_points.push("S") if has_south_border?
    cardinal_points
  end

  def is_not_a_sea?
    land_type.name != "sea"
  end

  def neutral_defense_points
    has_tribe ? land_type.conquest_points + 1 : land_type.conquest_points
  end

  def occupied?(players)
    players.any? { |player| player.occupied_regions.include?(self) }
  end

  def can_be_attacked?(player)
    player.can_attack_region?(self)
  end

  def has_west_border?
    id[0] == 1 && (1..rows).to_a.include?(id[1])
  end

  def has_east_border?
    id[0] == columns && (1..rows).to_a.include?(id[1])
  end

  def has_north_border?
    id[1] == 1 && (1..columns).to_a.include?(id[0])
  end

  def has_south_border?
    id[1] == rows && (1..columns).to_a.include?(id[0])
  end

end
