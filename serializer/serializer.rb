class Serializer

  def serialize_game_master_game_state(game_master)
    {
      "players"      => serialize_players(game_master.game_state.players),
      "raceboard"    => serialize_raceboard(game_master.game_state.raceboard),
      "map"          => serialize_map(game_master.game_state.map),
      "turn_tracker" => serialize_turn_tracker(game_master.game_state.turn_tracker),
      "rising_id"    => game_master.game_state.rising_id
    }
  end

  def serialize_players(players)
    players.map do |p|
      serialize_player(p)
    end
  end

  def serialize_player(player)
      occupied_regions = player.occupied_regions.map do |r|
        serialize_region(r)
      end
    {
      "name"             => player.name,
      "coins"            => player.coins,
      "cardinal_point"   => player.cardinal_point,
      "races"            => serialize_player_race(player),
      "occupied_regions" => occupied_regions,
      "color"            => player.color
    }
  end

  def serialize_player_race(player)
      player.races.map do |r|
         serialize_race(r)
      end
  end

  def serialize_raceboard(raceboard)
    {
      "races"        => raceboard.races.map {|r| serialize_race(r)},
      "race_choices" => raceboard.race_choices.map do |r, coins|
        [serialize_race(r), coins]
      end
    }
  end

  def serialize_race(race)
    {
      "name"          => race.name,
      "troops_number" => race.troops_number
    }
  end

  def serialize_map(game_map)
    map_regions = game_map.regions.map do |r|
      serialize_region(r)
    end
    { 
      "regions"    => map_regions,
      "width"      => game_map.width,
      "height"     => game_map.height,
      "grid_width" => game_map.grid_width
    }
  end

  def serialize_region(region)
     {
       "coordinates"    => region.coordinates,
       "land_type"      => serialize_land_type(region.land_type),
       "has_tribe"      => region.has_tribe,
       "id"             => region.id,
       "width"          => region.map_width,
       "height"         => region.map_height,
       "player_defense" => region.player_defense
     }
  end

  def serialize_land_type(land_type)
     {
       "name"            => land_type.name,
       "conquest_points" => land_type.conquest_points,
       "color"           => land_type.color
     }
  end

  def serialize_turn_tracker(turn_tracker)
    {
      "turns_left"  => turn_tracker.turns_left,
      "players"     => serialize_players(turn_tracker.players),
      "turn_played" => serialize_players(turn_tracker.turn_played),
      "actual_turn" => turn_tracker.actual_turn
    }
  end

end
