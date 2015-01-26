class SerializeTest < MiniTest::Unit::TestCase

  def setup
    setup_test
  end

  def test_if_serialize_method_serialize_game_master_game_state
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
    assert_equal exp, @serialize.serialize_game_master_game_state(@game_master)
  end

  private

  def setup_test
    setup_serialize
    setup_game_master_and_player
  end

  def setup_serialize
    @serialize = Serializer.new
  end

  def setup_game_master_and_player
    @game_master = GameMaster.new(GameState.new)
    @game_master.create_players([ "bob" ])
    @game_master.game_state.raceboard.races = [ Race.new("golems", 5) ]
    @game_master.game_state.raceboard.race_choices = [
      [ Race.new("dragons", 5), 0 ],
      [ Race.new("elves", 5), 0 ]
    ]
    @region_1 = Region.new(
      [
        { :x=>900.0, :y=>450.0 },
        { :x=>800.0, :y=>450.0 }
      ], 3, 3, 1)
    @region_1.land_type = LandType.new(
      "forest",
      2,
      "yellow"
    )
    @player = @game_master.game_state.players.first 
    @player.races[0] = Race.new("humans", 5)
    @player.occupied_regions[0] = @region_1
  end 

end
