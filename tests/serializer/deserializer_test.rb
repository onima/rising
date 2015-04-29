require 'coveralls'
Coveralls.wear!
require 'minitest/autorun'
require "serializer/deserializer.rb"
require "serializer/serializer.rb"
require "config/game_state.rb"
require "models/player.rb"
require "models/game_master.rb"
require "models/race.rb"
require "models/map.rb"
require "models/region.rb"
require "models/raceboard.rb"

class DeserializeTest < Minitest::Test

  def test_if_deserialize_game_master_game_state
    exp = {
      "players" =>
      [
        {
          "name" => "bob",
          "cardinal_point" => "North",
          "race" => [
          {
            "name" => "humans",
            "troops_number" => 5
          }
          ],
          "occupied_regions" => [
            {
           "land_type" => {
             "name" => "forest",
             "conquest_points" => 2,
             "color" => "yellow",
             "status_point" => "increasing"
           },
           "has_tribe" => nil,
           "id" => "1,1",
           "coordinates" => [1, 1],
           "columns" => 5,
           "rows" => 6,
           "player_defense" => nil
          }
          ],
          "color" => nil
        }
      ],
      "raceboard" => {
        "races" => [
          {
            "name" => "humans",
            "troops_number" => 5
          },
          {
            "name" => "orcs",
            "troops_number" => 5
          }
        ],
      },
      "map" => {
        "regions" => [{
           "land_type" => {
             "name" => "forest",
             "conquest_points" => 2,
             "color" => "yellow",
             "status_point" => "increasing"
           },
           "has_tribe" => nil,
           "id" => "1,1",
           "coordinates" => [1, 1],
           "columns" => 5,
           "rows" => 6,
           "player_defense" => nil
          }
        ],
      },
      "turn_tracker" => {
        "turns_left" => 10,
        "players" => [
        {
          "name" => "bob",
          "cardinal_point" => "North",
          "race" => [
          {
            "name" => "humans",
            "troops_number" => 5
          }
          ],
          "occupied_regions" => [
            {
           "land_type" => {
             "name" => "forest",
             "conquest_points" => 2,
             "color" => "yellow",
             "status_point" => "increasing"
           },
           "has_tribe" => nil,
           "id" => "1,1",
           "coordinates" => [1, 1],
           "columns" => 5,
           "rows" => 6,
           "player_defense" => nil
          }
          ],
          "color" => nil
        }
      ],
      "turn_played" => [
        {
          "name" => "bob",
          "cardinal_point" => "North",
          "race" => [
          {
            "name" => "humans",
            "troops_number" => 5
          }
          ],
          "occupied_regions" => [
            {
           "land_type" => {
             "name" => "forest",
             "conquest_points" => 2,
             "color" => "yellow",
             "status_point" => "increasing"
           },
           "has_tribe" => nil,
           "id" => "1,1",
           "coordinates" => [1, 1],
           "columns" => 5,
           "rows" => 6,
           "player_defense" => nil
          }
          ],
          "color" => nil
        }
      ],
      "actual_turn" => 1
      },
      "rising_id" => 1423065615.304268
    }
    game_master_game_state_deserialize = Deserializer.new.deserialize_game_master_game_state(exp)
    game_master_object = GameMaster.new(GameState.new)
    assert_equal game_master_game_state_deserialize.game_state.raceboard.races[0].name,
      game_master_object.game_state.raceboard.races[0].name
  end
end
