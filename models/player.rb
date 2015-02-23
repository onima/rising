require 'models/region'
require 'models/race'
require 'models/map'
require 'config/game_state'
require 'set'

class Player
  attr_reader :name
  attr_accessor :coins, :cardinal_point, :races, :occupied_regions, :color

  def initialize(name, cardinal_point)
    @name = name
    @coins = 5
    @cardinal_point = cardinal_point
    @races = Set.new
    @occupied_regions = Set.new #array_of_regions_occupied_by_the_player
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
    region.is_not_a_sea?               &&
    has_enough_troops?(region)         &&
    !occupied_regions.include?(region) &&
    (
      can_conquest_region_on_first_turn?(region) ||
      occupied_regions_have_border_with_region?(region)
    )
  end

  def can_conquest_region_on_first_turn?(region)
    @cardinal_point == "North" && region.external_borders.include?("N") ||
    @cardinal_point == "East"  && region.external_borders.include?("E") ||
    @cardinal_point == "South" && region.external_borders.include?("S") ||
    @cardinal_point == "West"  && region.external_borders.include?("W")
  end

  def has_enough_troops?(region)
      if region.has_tribe
        @races.first.troops_number >= region.land_type.conquest_points + 1
      else
        @races.first.troops_number >= region.land_type.conquest_points
      end
  end

  def occupied_regions_have_border_with_region?(region)
    @occupied_regions.any? do |occupied_region|
      (occupied_region.round_coordinates & region.round_coordinates).length == 2
    end
  end

  def can_yet_attack?(map)
    map.regions.any? do |region|
     occupied_regions.include?(region) == false && can_attack_region?(region)
    end
  end

  def price_of_race(race, game_state)
   game_state.raceboard.active_races.index(race)
  end

end
