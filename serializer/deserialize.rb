class Deserializer
  
  def deserialize_raceboard(raceboard)
    raceboard_object = GameMaster.new(GameState.new).game_state.raceboard
    raceboard_object.races.clear
    raceboard.map do |race|
      raceboard_object.races << deserialize_race(race) 
    end
    raceboard_object
  end

  def deserialize_race(race)
    Race.new(race[:name], race[:troops_number])
  end
end
