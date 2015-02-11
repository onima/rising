require 'config/game_state.rb'
class GameMaster
# Must To be Clean
  attr_accessor :game_state

  def initialize(game_state)
    @game_state = game_state
  end

  def create_players(players_names)
    raise IdenticalPlayersNames if players_names != players_names.uniq
    raise PlayersHaveBeenChosen unless game_state.players.empty?
    players_names.each do |name|
      raise PlayerDoNotHaveName unless /\A\w+\z/.match(name)
    end
    raise TooManyPlayers if players_names.length > 4
    actual_players = game_state.players
    cardinal_points = ["North", "East", "South", "West"]
    players_names.each do |name|
      actual_players << Player.new(name, cardinal_points.shift)
    end
  end

  def assign_players_color(players)
    colors = ["blue", "black", "red", "purple"].each
    players.each do |player|
      player.color = colors.next
    end
  end
end
