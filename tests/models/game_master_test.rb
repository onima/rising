require 'coveralls'
Coveralls.wear!
require 'minitest/autorun'
require "models/game_master"
require "errors"
class GameMasterTest < Minitest::Test

  def setup
    @game_master = GameMaster.new(GameState.new)
  end

  def test_create_players_raises_error_if_players_have_been_chosen
    @game_master.create_players( ["bob", "alice"] )
    assert_raises(PlayersHaveBeenChosen) {
      @game_master.create_players( ["greg", "bobby"] )
    }
  end

  def test_create_players_raise_error_if_there_are_too_many_players
    assert_raises(TooManyPlayers) { 
      @game_master.create_players( ["bob", "alice", "tim"] ) 
    }
  end

  def test_create_players_adds_players_to_the_game
    @game_master.create_players( ["alice", "bob"] )
    assert_equal 2, @game_master.game_state.players.length
    only_cardinals = @game_master.game_state.players.map do |player|
      player.cardinal_point
    end
    assert_equal ["North", "South"], only_cardinals
  end

  def test_create_player_raises_error_if_one_of_players_names_is_empty
    assert_raises(PlayerDoNotHaveName) {
      @game_master.create_players( ["bob", ""] )
    }
  end

  def test_create_player_raises_error_if_players_names_are_not_unique
    assert_raises(IdenticalPlayersNames) {
      @game_master.create_players( ["bob", "bob"] )
    }
  end

  def test_assign_players_color
    @game_master.create_players( ["bob", "alice"] )
    @game_master.assign_players_color(@game_master.game_state.players)
    assert_equal "blue", @game_master.game_state.players[0].color
    assert_equal "red", @game_master.game_state.players[1].color
  end

  def test_if_attribute_races
    @game_master.create_players( ["bob", "alice"] )
    @player_1 = @game_master.game_state.players[0]
    @player_2 = @game_master.game_state.players[1]
    @race_1 = Race.new("humans", 5)
    @game_master.attribute_races(@player_1, @race_1, @player_2)
    assert_equal "humans", @player_1.race.first.name
    assert_equal "orcs", @player_2.race.first.name
  end

  def test_if_check_if_players_names_method_is_valid
    assert @game_master.check_if_players_names_are_valid?("franck alex")
    refute @game_master.check_if_players_names_are_valid?("bobby")
  end

  def test_retrieve_player_name_method_returns_player_name
    @game_master.create_players( ["alice", "bob"] )
    player_name = 'alice'
    assert_equal 'alice', @game_master.retrieve_actual_player(player_name).name
    player_name = 'henry'
    assert_raises(PlayerNotFound) {
      @game_master.retrieve_actual_player(player_name)
    }
  end

  def test_retrieve_chosen_race_method_returns_race_name
    race_name = 'orcs'
    assert_equal 'orcs', @game_master.retrieve_chosen_race(race_name).to_a[0]
    race_name = 'dragons'
    assert_raises(RaceNameDoNotExist) {
      @game_master.retrieve_chosen_race(race_name)
    }
  end
end
