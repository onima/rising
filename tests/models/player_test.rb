require "models/race"
require "models/player"
require "models/map.rb"
require "models/region.rb"
require 'models/raceboard.rb'
require 'errors'
require 'config/game_state.rb'

class TestPlayer < MiniTest::Unit::TestCase

  def setup
    @state = GameState.new
    @state.reset!
    @map = MapDrawer.new.create_new_map(5,6, 400)
    @player = Player.new("alexis", "North")
    @player.races = [Race.new("humans", 5)].to_set
    @player_2 = Player.new("manue", "South")
    @player_2.races = [Race.new("orcs", 6)].to_set
    @player_3 = Player.new("tom", "East")
    @player_3.races = [Race.new("elves", 1)].to_set
    @raceboard = @state.raceboard
    @raceboard.pick_active_races
    @player.occupied_regions= [@map.regions[6],  @map.regions[18]].to_set
  end

  def test_price_of_race
    race = @raceboard.active_races[3]
    assert_equal 3, @player.price_of_race(race, @state)
  end

  def test_can_pay_for_race
    race = @raceboard.active_races[1]
    assert @player.can_pay_for_race?(race, @state)

    @player.pay(5)

    refute @player.can_pay_for_race?(race, @state)
  end

  def test_is_player_territories_has_borders_with_region
    assert @player.occupied_regions_have_border_with_region?(@map.regions[12])
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

  def test_if_player_can_yet_attack
    assert @player_2.can_yet_attack?(@map)
    refute @player_3.can_yet_attack?(@map)
  end

end
