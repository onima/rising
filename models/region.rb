require 'nokogiri'

class Region
  attr_accessor :id, :columns, :rows, :coordinates, :land_type, :has_tribe, :player_defense

  def initialize(id, columns, rows)
    @id = id
    @columns = columns
    @rows = rows
    @coordinates = id.split(',').map(&:to_i)
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
    coordinates[0] == 1 && (1..rows).cover?(coordinates[1])
  end

  def has_east_border?
    coordinates[0] == columns && (1..rows).to_a.include?(coordinates[1])
  end

  def has_north_border?
    coordinates[1] == 1 && (1..columns).to_a.include?(coordinates[0])
  end

  def has_south_border?
    coordinates[1] == rows && (1..columns).to_a.include?(coordinates[0])
  end

end
