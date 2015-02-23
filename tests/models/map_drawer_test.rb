require 'minitest/autorun'
require 'models/map.rb'
require 'models/map_drawer.rb'

class TestMapDrawer < Minitest::Test

  def setup
    @map_drawer = MapDrawer.new
    @map = @map_drawer.create_new_map(6, 5, 1000)
  end

  def test_find_hexagon_coordinates_returns_points_of_a_polygon
    assert_includes @map_drawer.find_hexagon_coordinates(450, 450, 450),
      ({"x"=>900.0, "y"=>450.0})
  end

  def test_assign_lands_randomly_assigns_lands_to_regions
    assert_equal 'sea' , @map_drawer.map.regions.first.land_type.name
    assert_equal 'sea' , @map_drawer.map.regions.last.land_type.name
    assert_includes %w(swamp hill forest mountain farmland),
      @map_drawer.map.regions[4].land_type.name
  end

  def test_map_have_differents_tribes_on_different_regions
    expected_tribes_number = (@map_drawer.regions_without_sea(@map).length) / MapDrawer::REGION_TRIBE_RATIO
    actual_tribes_number = @map_drawer.map.regions.count do |region|
      region.has_tribe == true
    end

    assert_equal expected_tribes_number, actual_tribes_number
    refute(@map_drawer.map.regions.first.has_tribe)
    refute(@map_drawer.map.regions.last.has_tribe)
  end

  def test_if_each_region_has_the_good_idea
    id_first_region = @map_drawer.map.regions.first.id
    id_last_region = @map_drawer.map.regions.last.id
    id_random_regions = @map_drawer.map.regions[7].id
    assert_equal 1, id_first_region
    assert_equal 30, id_last_region
    assert_equal 8, id_random_regions
  end
end
