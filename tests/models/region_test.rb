require 'minitest/autorun'
require 'models/region'

class TestRegion < MiniTest::Unit::TestCase
  def setup
    @region = Region.new([{"x"=>900.0, "y"=>450.0}, {"x"=>800.0, "y"=>450.0}], 3, 3, 1)
    @region.land_type = LandType.new("forest", 2, "yellow")
    @map = MapDrawer.new.create_new_map(5, 6, 400)
    @player = Player.new("alexis", "North")
  end

  def test_svg_coordinates_transform_coordinates_into_a_svg_string_of_points
    assert_equal "900.0,450.0 800.0,450.0 ", @region.svg_coordinates
  end

  def test_to_svg_transform_region_to_the_svg_format
    @player_1 = Player.new("alexis", "North")
    @player_2 = Player.new("louis", "East")
    @player_3 = Player.new("susy", "South")
    @players = [@player_1, @player_2, @player_3]
    assert_equal "<polygon style=\"fill:yellow;fill-opacity:0.7\" points=\"900.0,450.0 800.0,450.0 \"/>", @region.to_svg(@players)
  end

  def test_has_external_border_returns_true_if_it_is_on_a_corner
    assert @map.regions.first.has_external_border?
    assert @map.regions[2].has_external_border?
    assert @map.regions[6].has_external_border?
    assert @map.regions[4].has_external_border?
  end

  def test_has_external_border_returns_false_if_it_is_in_the_middle
    refute @map.regions[8].has_external_border?
  end

  def test_external_borders_returns_the_cardinal_points
    assert_equal ["W","N"], @map.regions.first.external_borders
    assert_equal ["W","S"], @map.regions[5].external_borders
    assert_equal ["N","E"], @map.regions[24].external_borders
    assert_equal ["E","S"], @map.regions.last.external_borders
  end

  def test_external_borders_returns_no_points_if_region_is_in_the_middle
    assert_equal [], @map.regions[8].external_borders
  end

  def test_if_region_is_not_a_sea
    refute @map.regions.first.is_not_a_sea?
    assert @map.regions[8].is_not_a_sea?
  end

  def test_if_region_is_occupied
    @player_1 = Player.new("alexis", "North")
    @player_2 = Player.new("louis", "East")
    @players = [@player_1, @player_2]
    @player_1.occupied_regions << @map.regions[12]
    assert @map.regions[12].occupied?(@players)
    refute @map.regions[13].occupied?(@players)
  end

end
