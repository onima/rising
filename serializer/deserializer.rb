class Deserializer

  def deserialize_game_master_game_state(hsh)
    game_master_object = GameMaster.new(GameState.new)
    raceboard_deserialize = deserialize_raceboard(
      hsh.fetch("raceboard")
    )
    players_deserialize = deserialize_players(
      hsh.fetch("players")
    )
    map_deserialize = deserialize_map(
      hsh.fetch("map")
    )
    turn_tracker_deserialize = deserialize_turn_tracker(
      hsh.fetch("turn_tracker")
    ) 
    rising_id_deserialize = hsh.fetch("rising_id")
    game_master_object.game_state.raceboard = raceboard_deserialize
    game_master_object.game_state.players = players_deserialize
    game_master_object.game_state.map = map_deserialize
    game_master_object.game_state.turn_tracker = turn_tracker_deserialize
    game_master_object.game_state.rising_id = rising_id_deserialize
    game_master_object
  end

  def deserialize_players(hsh)
    hsh.map do |p|
      deserialize_player(p)
    end
  end

  def deserialize_player(hsh)
    player_object = Player.new(
      hsh.fetch("name"),
      hsh.fetch("cardinal_point")
    )
    player_object.race = hsh.fetch("race").map do |race|
      deserialize_race(race)
    end.to_set
    occupied_regions = hsh.fetch("occupied_regions").map do |region|
      deserialize_region(region)
    end.to_set
    player_object.occupied_regions = occupied_regions
    player_object.color = hsh.fetch("color")
    player_object
  end

  def deserialize_raceboard(hsh)
    raceboard_object = RaceBoard.new(GameState::RULES)
    races = hsh.fetch("races").map do |r|
      deserialize_race(r)
    end
    raceboard_object.races = races
    raceboard_object
  end


  def deserialize_race(hsh)
    Race.new(
      hsh.fetch("name"),
      hsh.fetch("troops_number")
    )
  end

  def deserialize_map(hsh)
    deserialized_regions = hsh.fetch("regions").map do |r|
      deserialize_region(r)
    end
    map_object = Map.new
    map_object.regions = deserialized_regions
    map_object
  end

  def deserialize_land_type(hsh)
    LandType.new(
      hsh.fetch("name"),
      hsh.fetch("conquest_points"),
      hsh.fetch("color")
    )
  end

  def deserialize_region(hsh)
    region_object = Region.new(
      hsh.fetch("id"), hsh.fetch("columns"), hsh.fetch("rows")
    )
    region_object.coordinates = hsh.fetch("coordinates")
    region_object.land_type = deserialize_land_type(hsh.fetch("land_type"))
    region_object.has_tribe = hsh.fetch("has_tribe")
    region_object.player_defense = hsh.fetch("player_defense")
    region_object
  end

  def deserialize_turn_tracker(hsh)
    players_deserialized = deserialize_players(
      hsh.fetch("players")
    )
    turn_tracker_object = TurnTracker.new(
      hsh.fetch("turns_left"),
      players_deserialized
    )
    turn_tracker_object.turn_played = deserialize_players(hsh.fetch("turn_played"))
    turn_tracker_object.actual_turn = hsh.fetch("actual_turn")
    turn_tracker_object
  end

end
