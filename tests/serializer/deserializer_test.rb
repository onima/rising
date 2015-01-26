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

  def test_if_deserialize_game_master_game_state
    exp = {
      players:
      [
        {
          name: "bob",
          coins: 5,
          cardinal_point: "North",
          races: [
          {
            name: "humans",
            troops_number: 5
          }
          ],
          occupied_regions: [
            {
            coordinates: [
              { x: 900.0, y: 450.0 },
              { x: 800.0, y: 450.0 }
            ],
           land_type: {
             name: "forest",
             conquest_points: 2,
             color: "yellow"
           },
           has_tribe: nil,
           id: 1,
           width: 3,
           height: 3, 
           player_defense: nil
          }
          ],
          color: nil
        }
      ],
      raceboard: {
        races: [
          {
            name: "golems",
            troops_number: 5
          },
        ],
        race_choices: [
          [
            {
              name: "dragons",
              troops_number: 5
            }, 0 
          ],
          [
            {
              name: "elves",
              troops_number: 5
            }, 0 
          ]
        ]
      }
    }
    game_master_game_state_deserialize = Deserializer.new.deserialize_game_master_game_state(exp)
    game_master_object = GameMaster.new(GameState.new)
    assert_equal game_master_game_state_deserialize.game_state.raceboard.races[0].name,
      game_master_object.game_state.raceboard.races[0].name
  end
end
