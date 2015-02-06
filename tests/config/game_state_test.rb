class TestGameState < MiniTest::Unit::TestCase

  def test_if_initialize_map_turn_tracker_orgiac_id_method_works
    @game_state = GameState.new
    @game_state.initialize_map_turn_tracker_orgiac_id
    assert @game_state.map
  end

end
