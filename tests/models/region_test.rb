require 'coveralls'
Coveralls.wear!
require 'minitest/autorun'
require 'models/region'

class TestRegion < Minitest::Test
  def setup
    @map = Map.new
    @region_3 = @map.regions[2]
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

  def test_if_region_is_attackable
    @player_1 = Player.new("alexis", "North")
    @player_1.occupied_regions << @map.regions[12]
    @player_1.races = [Race.new("orcs", 6)].to_set
    assert @map.regions[13].can_be_attacked?(@player_1)
    assert @map.regions[7].can_be_attacked?(@player_1)
    refute @map.regions[14].can_be_attacked?(@player_1)
  end

end
