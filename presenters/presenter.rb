class GamePresenter

  attr_accessor :game_master

  def initialize(game_master)
    @game_master = game_master
  end

  def players
    @game_master.game_state.players
  end

  def players_without_race
    @game_master.game_state.players_without_race?
  end

  def player
    actual_player_index = @game_master.game_state.turn_tracker.turn_played.count
    players.at(actual_player_index)
  end

  def race_choices
    @game_master.game_state.raceboard.race_choices
  end

  def active_races
    @game_master.game_state.raceboard.active_races
  end

  def map
    @game_master.game_state.map
  end

  def turn_tracker
    @game_master.game_state.turn_tracker
  end

end
