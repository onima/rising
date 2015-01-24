class Serializer
  
  def serialize_game_master_game_state(game_master)
    {
      players:   serialize_players(game_master.game_state.players),
      raceboard: serialize_raceboard(game_master.game_state.raceboard)
    }
  end
  
  def serialize_players(players)
    players.map do |player|
      serialize_player(player)
    end
  end

  def serialize_raceboard(raceboard)
    {
      races:        raceboard.races.map {|race| serialize_race(race)},
      race_choices: []
    }
  end

  def serialize_player(player)
      occupied_regions = player.occupied_regions.map do |region|
        serialize_region(region)
      end 
    {
      name:             player.name,
      coins:            player.coins,
      cardinal_point:   player.cardinal_point,
      race:             serialize_player_race(player),
      occupied_regions: occupied_regions, 
      color:            player.color
    } 
  end

  def serialize_region(region)
     {
       coordinates:    region.coordinates,
       land_type:      serialize_land_type(region.land_type),
       has_tribe:      region.has_tribe,
       id:             region.id,
       player_defense: region.player_defense
     }
  end

  def serialize_land_type(land_type)
     {
       name:            land_type.name,
       conquest_points: land_type.conquest_points,
       color:           land_type.color
     }
  end

  def serialize_race(race)
    {
      name:          race.name,
      troops_number: race.troops_number
    }
  end

  def serialize_player_race(player)
    races = []
    if player.races.any?
      player.races.map do |race|
        races << serialize_race(race)
      end
    else
      races 
    end
    races
  end

end
