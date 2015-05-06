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
    raise TooManyPlayers if players_names.length > 2
    cardinal_points = ["North", "South"]
    players_names.each do |name|
      @game_state.players << Player.new(name, cardinal_points.shift)
    end
  end

  def assign_players_color(players)
    colors = ["blue", "red"]
    players.zip(colors).each do |player, color|
      player.color = color
    end
  end

  def attribute_races(player_1, chosen_race, player_2)
    other_race = @game_state.raceboard.races.find { |race| race != chosen_race }
    @game_state.raceboard.pick_race(chosen_race, player_1)
    @game_state.raceboard.pick_race(other_race, player_2)
  end

  def retrieve_chosen_race(race_name)
    if race_name == 'orcs' || race_name == 'humans'
      @game_state.raceboard.races.find { |r| r.name == race_name}
    else
      raise RaceNameDoNotExist
    end
  end

end
