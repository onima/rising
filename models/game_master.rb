require 'config/game_state.rb'
class GameMaster

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
    cardinal_points = ["North", "East", "South", "West"]
    players_names.each do |name|
      @game_state.players << Player.new(name, cardinal_points.shift)
    end
  end

  def assign_players_color(players)
    colors = ["blue", "black", "red", "purple"]
    players.zip(colors).each do |player, color|
      player.color = color
    end
  end

  def attribute_race(player, race)
    if race && player && player.can_pay_for_race?(race, @game_state)
      @game_state.raceboard.pick_race(race, player)
    else
      raise RaceNotAssign 
    end
  end

  def check_if_players_names_are_valid?(players_params)
    !players_params.include?(",") && players_params.split.count > 1
  end
end
