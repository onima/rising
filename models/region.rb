require 'nokogiri'

class Region < Struct.new(:id)
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

  private

  def has_west_border?
    [1,2,3,4,5,6].include?(id)
  end

  def has_east_border?
    [25,26,27,28,29,30].include?(id)
  end

  def has_north_border?
    [1,7,13,19,25].include?(id)
  end

  def has_south_border?
    [6,12,18,24,30].include?(id)
  end

end
