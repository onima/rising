class GameMaster
  def create_players(players_names)
    raise IdenticalPlayersNames if players_names != players_names.uniq
    raise PlayersHaveBeenChosen unless GameState.instance.players.empty?
    players_names.each { |name| raise PlayerDoNotHaveName unless /\A\w+\z/.match(name) }
    raise TooManyPlayers if players_names.length > 4

    actual_players = GameState.instance.players
    cardinal_points = ["North", "East", "South", "West"]
    players_names.each { |name| actual_players << Player.new(name, cardinal_points.shift) }
  end

  def assign_players_color(players)
    colors = ["blue", "black", "red", "purple"].each
    players.each do |player|
      player.color = colors.next
    end
  end
end
