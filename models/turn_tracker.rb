class TurnTracker
  attr_accessor :turns_left, :players, :turn_played, :actual_turn

  def initialize(turns_left, players)
    @turns_left = turns_left
    @players = players
    @turn_played = []
    @actual_turn = 1
  end

  def update(player)
    @turn_played << player
    @turns_left -= 1 if turn_played_by_all
    @actual_turn += 1 if turn_played_by_all
    @turn_played.clear if turn_played_by_all
  end

  private

  def turn_played_by_all
    @turn_played.length == @players.length
  end

end
