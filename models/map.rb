require 'models/region.rb'
require 'models/land_type.rb'

class Map

  REGION_TRIBE_RATIO = 4

  attr_accessor :regions

  def initialize
    @regions = (1..30).map { |n| Region.new(n) } 
    require 'pry'; binding.pry 
    assign_lands
    assign_tribes
  end

  def land_types
    GameState::LAND_TYPES
  end

  def assign_lands
    [@regions.first, @regions.last, @regions[middle_region(map)]].each do |region|
      region.land_type = sea_land_type
    end
    regions_without_sea.each do |region|
      region.land_type = land_types_without_sea.sample
    end
  end

  def assign_tribes
    number_of_tribes = (regions_without_sea.length) / REGION_TRIBE_RATIO
    regions_occupied_by_tribes = regions_without_sea.sample(number_of_tribes)
    regions_occupied_by_tribes.each do |region_occupied|
      region_occupied.has_tribe = true
    end
  end

  def regions_without_sea
   regions_without_sea = @regions.map.with_index do |region, i|
     region if region_is_not_sea?(i)
   end
     regions_without_sea.compact
  end

  private

  def region_is_not_sea?(index)
    index != 0 &&  index != middle_region && index != (@regions.length - 1)
  end

  def sea_land_type
    land_types.find { |land_type| land_type.name == 'sea' }
  end

  def land_types_without_sea
    land_types.reject { |land_type| land_type.name == 'sea' }
  end

  def middle_region
    (@regions.length) / 2
  end
end
