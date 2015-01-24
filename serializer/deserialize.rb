class Deserializer

  def deserialize_game_master_game_state(game_master)
    game_master_object = GameMaster.new(GameState.new)
    raceboard_deserialize = deserialize_raceboard(
      game_master.fetch(:raceboard)
    )
    players_deserialize = deserialize_players(
      game_master.fetch(:players)
    )
    game_master_object.game_state.raceboard = raceboard_deserialize
    game_master_object.game_state.players = players_deserialize
    game_master_object
  end

  def deserialize_raceboard(hsh)
    raceboard = RaceBoard.new(GameState::RULES)
    races = hsh.fetch(:races).map do |race|
      deserialize_race(race)
    end
    raceboard.races = races
    raceboard
  end

  def deserialize_players(players)
    players.map do |player|
      deserialize_player(player)
    end
  end

  def deserialize_player(player)
    player_object = Player.new(
      player.fetch(:name),
      player.fetch(:cardinal_point)
    )
    player_object.coins = player.fetch(:coins)
    player_object.races = [deserialize_race(player.fetch(:race))]
    occupied_regions = player.fetch(:occupied_regions).map do |region|
      deserialize_region(region)
    end
    player_object.occupied_regions = occupied_regions
    player_object.color = player.fetch(:color)
    player_object
  end

  def deserialize_race(race)
    Race.new(
      race.fetch(:name),
      race.fetch(:troops_number)
    )
  end

  def deserialize_land_type(land_type)
    LandType.new(
      land_type.fetch(:name),
      land_type.fetch(:conquest_points),
      land_type.fetch(:color)
    )
  end

  def deserialize_region(region)
    region_object = Region.new(
      region.fetch(:coordinates),
      region.fetch(:width),
      region.fetch(:height),
      region.fetch(:id)
    )
    region_object.land_type = deserialize_land_type(region.fetch(:land_type))
    region_object.has_tribe = region.fetch(:has_tribe)
    region_object.player_defense = region.fetch(:player_defense)
    region_object
  end

end
