require 'models/map'
require 'models/map_drawer'

class TestMapDrawer < MiniTest::Unit::TestCase
  def setup
    map = Map.new(6,5,1000)
    @map_drawer = MapDrawer.new(map)
  end

  def test_find_hexagon_coordinates_returns_points_of_a_polygon
    assert_includes @map_drawer.find_hexagon_coordinates(450, 450, 450), ({:x=>900.0, :y=>450.0})
  end

  def test_assign_lands_randomly_assigns_lands_to_regions

    assert_equal 'sea' , @map_drawer.map.regions.first.land_type.name
    assert_equal 'sea' , @map_drawer.map.regions.last.land_type.name
    assert_includes %w(swamp hill forest mountain farmland), @map_drawer.map.regions[4].land_type.name
  end

  def test_returns_a_visual_description_of_the_land_types
    @map_drawer.map.regions.map do |region|
      puts "Region with id #{region.id} has land type #{region.land_type.name}"
    end
  end

  def test_map_have_differents_tribes_on_different_regions
    expected_tribes_number = (@map_drawer.regions_without_sea.length) / MapDrawer::REGION_TRIBE_RATIO
    actual_tribes_number = @map_drawer.map.regions.count {|region| region.has_tribe == true}

    assert_equal expected_tribes_number, actual_tribes_number
    refute(@map_drawer.map.regions.first.has_tribe)
    refute(@map_drawer.map.regions.last.has_tribe)
  end

  def test_returns_a_visual_description_of_the_land_types
    @map_drawer.map.regions.map do |region|
      puts "Region with id #{region.id} has tribe?: #{region.has_tribe}"
    end
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
