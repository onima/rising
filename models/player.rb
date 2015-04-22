require 'models/region'
require 'models/race'
require 'models/map'
require 'config/game_state'
require 'set'

class Player
  attr_reader :name
  attr_accessor :cardinal_point, :race, :occupied_regions, :color

  def initialize(name, cardinal_point)
    @name = name
    @cardinal_point = cardinal_point
    @race = Set.new
    @occupied_regions = []
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
    @cardinal_point == "South" && region.external_borders.include?("S")
  end

  def has_enough_troops?(region)
      if region.has_tribe
        @race.first.troops_number >= region.land_type.conquest_points + 1
      else
        @race.first.troops_number >= region.land_type.conquest_points
      end
  end

  def occupied_regions_have_border_with_region?(region)
    west_last_region, east_last_region =
      if region.coordinates[0].odd?
        [
          [region.coordinates[0] - 1, region.coordinates[1] + 1],
          [region.coordinates[0] + 1, region.coordinates[1] + 1]
        ]
      else
        [
          [region.coordinates[0] - 1, region.coordinates[1] - 1],
          [region.coordinates[0] + 1, region.coordinates[1] - 1]
        ]
      end

    regions_which_have_borders_with_region =
      [
        [region.coordinates[0], region.coordinates[1] - 1],
        [region.coordinates[0], region.coordinates[1] + 1],
        [region.coordinates[0] - 1, region.coordinates[1]],
        [region.coordinates[0] + 1, region.coordinates[1]],
        west_last_region, east_last_region
      ]

    @occupied_regions.any? do |occupied_region|
      regions_which_have_borders_with_region.include?(occupied_region.coordinates)
    end
  end

  def can_yet_attack?(map)
    map.regions.any? do |region|
     occupied_regions.include?(region) == false && can_attack_region?(region)
    end
  end

end
