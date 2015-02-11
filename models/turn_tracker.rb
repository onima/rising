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
    if turn_played_by_all
      @turns_left -= 1
      @actual_turn += 1
      @turn_played.clear
    end
  end

  private

  def turn_played_by_all
    @turn_played.length == @players.length
  end

end
