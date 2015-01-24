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

  def test_if_race_deserialize
    race_deserialize = Deserializer.new.deserialize_race(
      {
        name:          "humans",
        troops_number: 5
      }
    )
    assert_equal Race.new("humans", 5).name, race_deserialize.name
  end

  def test_if_raceboard_deserialize
    raceboard_deserialize = Deserializer.new.deserialize_raceboard(
      {
        races: [
          {
            name:          "golems",
            troops_number: 5
          },
          {
            name:          "dragons",
            troops_number: 3
          },
          {
            name:          "elves",
            troops_number: 6
          },
          { 
            name:          "undeads",
            troops_number: 6
          },
          { 
            name:          "giants",
            troops_number: 4
          },
          { 
            name:          "centaurs",
            troops_number: 7
          },
          {
            name:          "humans",
            troops_number: 5
          },
          { 
            name:          "orcs",
            troops_number: 5
          },
          {
            name:          "dwarves",
            troops_number: 6
          },
          {
            name:          "skeletons",
            troops_number: 8
          },
          {
            name:          "sorcerers",
            troops_number: 5
          },
          {
            name:          "tritons",
            troops_number: 8
          },
          {
            name:          "trolls",
            troops_number: 5
          },
          {
            name:          "demons",
            troops_number: 3
          } 
        ], 
        race_choices: []
      }
    )
   raceboard_test_object = GameMaster.new(GameState.new).game_state.raceboard

   races_names_array_1 = raceboard_deserialize.races.map do |race|
     race.name
   end

   races_names_array_2 = raceboard_test_object.races.map do |race|
    race.name
   end 

   assert_equal races_names_array_1, races_names_array_2
  end

  def test_if_deserialize_land_type
    deserialize_land_type = Deserializer.new.deserialize_land_type(
      {
        name:            "forest",
        conquest_points: 2,
        color:           "yellow"
      }
    )
    land_type_object = LandType.new("forest", 2, "yellow")
    assert_equal land_type_object.name, deserialize_land_type.name
  end

  def test_if_deserialize_region
    deserialize_region = Deserializer.new.deserialize_region(
      {
        coordinates: [
          {
            x: 900.0,
            y: 450.0
          },
          {
            x: 800.0,
            y: 450.0
          } 
        ],
        land_type: {
          name:            "forest",
          conquest_points: 2,
          color:           "yellow"
        },
        has_tribe:      true,
        id:             7,
        player_defense: true
      }
    )
    region_object = Region.new(
      [
        {
          x: 900.0,
          y: 450.0
        },
        {
          x: 800.0,
          y: 450.0
        }
      ],
      3,
      3,
      7
    )
    assert_equal region_object.coordinates, deserialize_region.coordinates
  end

  def test_if_deserialize_player
    deserialize_player = Deserializer.new.deserialize_player(
      {
        name:               "alexis",
        coins:              5,
        cardinal_point:     "North",
        race: {
          name:          "humans",
          troops_number: 5
        },
        occupied_regions:   [
          { 
            coordinates: [
              {
                x: 900.0,
                y: 450.0
              },
              {
                x: 800.0, 
                y: 450.0
              }
            ],
            land_type: {
              name:            "forest",
              conquest_points: 2,
              color:           "yellow" 
            },
            has_tribe:      nil,
            id:             7,
            player_defense: nil
          }
        ],
        color:              nil
      }
    )
    player_object = Player.new("alexis", "North")
    assert_equal player_object.name, deserialize_player.name
  end

  def test_if_deserialize_players
    deserialize_players = Deserializer.new.deserialize_players(
      [
        {
        name:               "alexis",
        coins:              5,
        cardinal_point:     "North",
        race: {
          name:          "humans",
          troops_number: 5
        },
        occupied_regions:   [
          { 
            coordinates: [
              {
                x: 900.0,
                y: 450.0
              },
              {
                x: 800.0, 
                y: 450.0
              }
            ],
            land_type: {
              name:            "forest",
              conquest_points: 2,
              color:           "yellow" 
            },
            has_tribe:      nil,
            id:             7,
            player_defense: nil
          }
        ],
        color:              nil
      },
      {
        name:               "tom",
        coins:              5,
        cardinal_point:     "East",
        race: {
          name:          "dragons",
          troops_number: 3
        },
        occupied_regions:   [
          { 
            coordinates: [
              {
                x: 900.0,
                y: 450.0
              },
              {
                x: 800.0, 
                y: 450.0
              }
            ],
            land_type: {
              name:            "forest",
              conquest_points: 2,
              color:           "yellow" 
            },
            has_tribe:      nil,
            id:             7,
            player_defense: nil
          }
        ],
        color:              nil
      },
      ]
    )
    players_object = [
      Player.new("alexis", "North"),
      Player.new("tom", "East")
    ]
    assert_equal players_object[0].name, deserialize_players[0].name 
  end

  def test_if_deserialize_game_master_game_state
    game_master_game_state_deserialize = Deserializer.new.deserialize_game_master_game_state(
      {
      players:
      [
        {
          name:             "alexis",
          coins:            5,
          cardinal_point:   "North",
          race:             {
            name:          "golems",
            troops_number: 5
          },
          occupied_regions: [],
          color:            nil
        }
      ],
      raceboard:
      {
        races: [
          {
            name:          "golems",
            troops_number: 5
          },
          { 
            name:          "dragons",
            troops_number: 3
          },
          {
            name:          "elves",
            troops_number: 6
          },
          {
            name:          "undeads",
            troops_number: 6
          },
          {
            name:          "giants",
            troops_number: 4
          },
          { 
            name:          "centaurs",
            troops_number: 7
          },
          { 
            name:          "humans",
            troops_number: 5
          },
          {
            name:          "orcs",
            troops_number: 5
          },
          {
            name:          "dwarves",
            troops_number: 6
          },
          {
            name:          "skeletons",
            troops_number: 8
          },
          { 
            name:          "sorcerers",
            troops_number: 5
          },
          {
            name:          "tritons",
            troops_number: 8
          },
          {
            name:          "trolls",
            troops_number: 5
          },
          {
            name:          "demons",
            troops_number: 3
          }
        ], 
        race_choices: []
      }
    }
  )
    game_master_object = GameMaster.new(GameState.new)
    assert_equal game_master_object.game_state.raceboard.races[0].name,
      game_master_game_state_deserialize.game_state.raceboard.races[0].name
  end
end
