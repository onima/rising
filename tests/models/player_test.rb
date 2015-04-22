require 'coveralls'
Coveralls.wear!
require 'minitest/autorun'
require "models/race"
require "models/player"
require "models/map.rb"
require "models/region.rb"
require 'models/raceboard.rb'
require 'errors'
require 'config/game_state.rb'

class TestPlayer < Minitest::Test

  def setup
    @state = GameState.new
    @state.reset!
    @map = Map.new
    @player = Player.new("alexis", "North")
    @player.race = [Race.new("humans", 15)].to_set
    @player.occupied_regions = [@map.regions[6],  @map.regions[18]]
    @player_2 = Player.new("manue", "South")
    @player_2.race = [Race.new("orcs", 15)].to_set
    @player_2.occupied_regions = [@map.regions[12]]
  end

  def test_is_player_territories_has_borders_with_region
    assert @player_2.occupied_regions_have_border_with_region?(@map.regions[7])
  end

  def test_if_player_can_conquest_region_on_first_turn
    assert @player.can_conquest_region_on_first_turn?(@map.regions.first)
    assert @player_2.can_conquest_region_on_first_turn?(@map.regions[11])
  end

  def test_if_player_has_enough_troops?
    assert @player.has_enough_troops?(@map.regions[8])
  end

  def test_if_player_can_attack_region
    assert @player.can_attack_region?(@map.regions[19])
    refute @player.can_attack_region?(@map.regions.first)
    assert @player_2.can_attack_region?(@map.regions[17])
    refute @player_2.can_attack_region?(@map.regions.last)
  end

  def test_player_cannot_attack_owned_region
    refute @player.can_attack_region?(@map.regions[6])
  end

  def test_if_player_can_yet_attack
    assert @player_2.can_yet_attack?(@map)
  end

end
