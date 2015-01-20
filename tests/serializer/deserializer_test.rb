require "serializer/deserialize.rb"
require "serializer/serialize.rb"
require "config/game_state.rb"
require "models/player.rb"
require "models/game_master.rb"
require "models/race.rb"
require "models/map.rb"
require "models/region.rb"
require "models/raceboard.rb"

class DeserializeTest < MiniTest::Unit::TestCase

  def setup
    @game_master = GameMaster.new(GameState.new)
    @game_master.create_players(["bob"])
    @player = @game_master.game_state.players.first
  end

  def test_if_race_deserialize
    race_deserialize = Deserializer.new.deserialize_race(
      {
        :name=>"humans",
        :troops_number=>5
      }
    )
    assert_equal Race.new("humans", 5).name, race_deserialize.name
  end

  def test_if_raceboard_deserialize
    raceboard = @game_master.game_state.raceboard
    raceboard_object_2 = GameMaster.new(GameState.new).game_state.raceboard 
    raceboard_serialize = Serializer.new.serialize_raceboard(raceboard)
    raceboard_deserialize = Deserializer.new.deserialize_raceboard(raceboard_serialize)
    raceboard_races_array_object_2 = raceboard_object_2.races.map do |race|
      race.name
    end
    raceboard_deserialize_array = raceboard_deserialize.races.map do |race|
      race.name
    end
    assert_equal raceboard_races_array_object_2, raceboard_deserialize_array
    require 'pry'; binding.pry
  end

end
