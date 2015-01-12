require "models/game_master"
require "errors"
class GameMasterTest < MiniTest::Unit::TestCase
  def setup
    @state = GameState.instance
    @state.reset!
    @game_master = GameMaster.new
  end

  def test_create_players_raises_error_if_players_have_been_chosen
    @state.players = ["alice", "bob"]
    assert_raises(PlayersHaveBeenChosen) {@game_master.create_players(["greg", "bobby"])}
  end

  def test_create_players_raise_error_if_there_are_too_many_players
    assert_raises(TooManyPlayers) {@game_master.create_players(["bob", "alice", "tim", "tob", "bryan"])}
  end

  def test_create_players_adds_players_to_the_game
    @game_master.create_players(["alice", "bob", "jack", "george"])
    assert_equal(4, @state.players.length)
    only_cardinals = @state.players.map {|player| player.cardinal_point }
    assert_equal(["North","East","South","West"], only_cardinals)
  end

  def test_create_player_raises_error_if_one_of_players_names_is_empty
    assert_raises(PlayerDoNotHaveName) {@game_master.create_players(["bob", "alice", "tim", "  "])}
  end

  def test_create_player_raises_error_if_players_names_not_unique
    assert_raises(IdenticalPlayersNames) { @game_master.create_players(["bob", "alice","bob"]) }
  end

  def test_assign_players_color
    @game_master.create_players(["bob", "alice", "susy", "andrew"])
    @game_master.assign_players_color(@state.players)
    assert_equal "blue", @state.players[0].color
  end
end
