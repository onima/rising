class Deserializer

  def deserialize_game_master_game_state(hsh)
    game_master_object = GameMaster.new(GameState.new)
    raceboard_deserialize = deserialize_raceboard(
      hsh.fetch(:raceboard)
    )
    players_deserialize = deserialize_players(
      hsh.fetch(:players)
    )
    game_master_object.game_state.raceboard = raceboard_deserialize
    game_master_object.game_state.players = players_deserialize
    game_master_object
  end

  def deserialize_raceboard(hsh)
    raceboard = RaceBoard.new(GameState::RULES)
    races = hsh.fetch(:races).map do |r|
      deserialize_race(r)
    end
    race_choices_array = hsh.fetch(:race_choices).map do |r|
      [deserialize_race(r.first), r.last]
    end
    raceboard.races = races
    raceboard.race_choices = race_choices_array
    raceboard
  end

  def deserialize_players(hsh)
    hsh.map do |p|
      deserialize_player(p)
    end
  end

  def deserialize_player(hsh)
    player_object = Player.new(
      hsh.fetch(:name),
      hsh.fetch(:cardinal_point)
    )
    player_object.coins = hsh.fetch(:coins)
    player_object.races = hsh.fetch(:races).map do |race|
      deserialize_race(race)
    end
    occupied_regions = hsh.fetch(:occupied_regions).map do |region|
      deserialize_region(region)
    end
    player_object.occupied_regions = occupied_regions
    player_object.color = hsh.fetch(:color)
    player_object
  end

  def deserialize_race(hsh)
    Race.new(
      hsh.fetch(:name),
      hsh.fetch(:troops_number)
    )
  end

  def deserialize_land_type(hsh)
    LandType.new(
      hsh.fetch(:name),
      hsh.fetch(:conquest_points),
      hsh.fetch(:color)
    )
  end

  def deserialize_region(hsh)
    region_object = Region.new(
      hsh.fetch(:coordinates),
      hsh.fetch(:width),
      hsh.fetch(:height),
      hsh.fetch(:id)
    )
    region_object.land_type = deserialize_land_type(hsh.fetch(:land_type))
    region_object.has_tribe = hsh.fetch(:has_tribe)
    region_object.player_defense = hsh.fetch(:player_defense)
    region_object
  end

end
