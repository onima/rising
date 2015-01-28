require 'models/region.rb'
require 'models/race.rb'
require 'models/map.rb'
require 'config/game_state.rb'

class Player
  attr_reader :name
  attr_accessor :coins, :cardinal_point, :races, :occupied_regions, :color

  def initialize(name, cardinal_point)
    @name = name
    @coins = 5
    @cardinal_point = cardinal_point
    @races = []
    @occupied_regions= [] #array_of_regions_occupied_by_the_player
  end

  def can_pay_for_race?(race, game_state)
    coins >= price_of_race(race, game_state)
  end

  def pay_for_race(race)
    pay(price_of_race(race))
  end

  def pay(coins)
    @coins -= coins
  end

  def can_attack_region?(region)
    region.is_not_a_sea? && has_enough_troops?(region) && (can_conquest_region_on_first_turn?(region) || occupied_regions_have_border_with_region?(region))
  end

  def can_conquest_region_on_first_turn?(region)
    @cardinal_point == "North" && region.external_borders.include?("N") || @cardinal_point == "East" && region.external_borders.include?("E") || @cardinal_point == "South" && region.external_borders.include?("S") || @cardinal_point == "West" && region.external_borders.include?("W")
  end

  def has_enough_troops?(region)
      region.has_tribe ? @races[0].troops_number >= region.land_type.conquest_points + 1 : @races[0].troops_number >= region.land_type.conquest_points
  end

  def occupied_regions_have_border_with_region?(region)
    @occupied_regions.any? {|occupied_region| (occupied_region.round_coordinates & region.round_coordinates).length == 2}
  end

  def can_yet_attack?(map)
    bool = false
    map.regions.each do |region|
     bool = true if (occupied_regions.include?(region) == false) && (can_attack_region?(region))
    end
    bool
  end

  def price_of_race(race, game_state)
   game_state.raceboard.active_races.index(race)
  end

end
