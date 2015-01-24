class SerializeTest < MiniTest::Unit::TestCase
  
  def setup
    @state = GameState.new
    @state.reset!
    @serialize = Serializer.new
  end

  def test_if_serialize_method_serialize_game_master_game_state
    exp = {
      players:
      [
        {
          name:             "bob",
          coins:            5,
          cardinal_point:   "North",
          race:             [],
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
    @game_master = GameMaster.new(GameState.new)
    @game_master.create_players(["bob"])
    assert_equal exp, @serialize.serialize_game_master_game_state(@game_master)
  end

  def test_if_serialize_method_serialize_players
    @region_1 = Region.new(
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
    @region_1.land_type = LandType.new("forest", 2, "yellow")
    @player = Player.new("alexis", "North")
    @player.races[0] = Race.new("humans", 5)
    @player.occupied_regions[0] = @region_1 
    @state.players = [@player]
    exp = [
      {
        name:             "alexis",
        coins:            5,
        cardinal_point:   "North",
        race:             [
          {
            name:          "humans",
            troops_number: 5
          }
        ],
        occupied_regions: [
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
           land_type: 
           {
             name:            "forest",
             conquest_points: 2,
             color:           "yellow" 
           },
           has_tribe:      nil,
           id:             7,
           player_defense: nil
          }
        ],
        color:           nil
      }
    ]
    assert_equal exp, @serialize.serialize_players(@state.players)
  end

  def test_if_serialize_method_serialize_raceboard 
    @raceboard = @state.raceboard
    exp = 
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
    @serialize.serialize_raceboard(@raceboard)
    assert_equal exp, @serialize.serialize_raceboard(@raceboard)
  end

end
