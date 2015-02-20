require 'minitest/autorun'
class SerializeTest < Minitest::Test

  def setup
    setup_test
  end

  def test_if_serialize_method_serialize_game_master_game_state
    exp = {
      "players" =>
      [
        {
          "name" => "bob",
          "coins" => 5,
          "cardinal_point" => "North",
          "races" => [
          {
            "name" => "humans",
            "troops_number" => 5
          }
          ],
          "occupied_regions" => [
            {
            "coordinates" => [
              { "x" => 900.0, "y" => 450.0 },
              { "x" => 800.0, "y" => 450.0 }
            ],
           "land_type" => {
             "name" => "forest",
             "conquest_points" => 2,
             "color" => "yellow"
           },
           "has_tribe" => nil,
           "id" => 1,
           "width" => 3,
           "height" => 3,
           "player_defense" => nil
          }
          ],
          "color" => nil
        }
      ],
      "raceboard" => {
        "races" => [
          {
            "name" => "golems",
            "troops_number" => 5
          },
        ],
        "race_choices" => [
          [
            {
              "name" => "dragons",
              "troops_number" => 5
            }, 0 
          ],
          [
            {
              "name" => "elves",
              "troops_number" => 5
            }, 0 
          ]
        ]
      },
      "map" => {
        "regions" => [{
            "coordinates" => [
              { "x" => 900.0, "y" => 450.0 },
              { "x" => 800.0, "y" => 450.0 }
            ],
           "land_type" => {
             "name" => "forest",
             "conquest_points" => 2,
             "color" => "yellow"
           },
           "has_tribe" => nil,
           "id" => 1,
           "width" => 3,
           "height" => 3,
           "player_defense" => nil
          }
        ],
        "width" => 6,
        "height" => 5,
        "grid_width" => 1000
      },
      "turn_tracker" => {
        "turns_left" => 10,
        "players" => [
        {
          "name" => "bob",
          "coins" => 5,
          "cardinal_point" => "North",
          "races" => [
          {
            "name" => "humans",
            "troops_number" => 5
          }
          ],
          "occupied_regions" => [
            {
            "coordinates" => [
              { "x" => 900.0, "y" => 450.0 },
              { "x" => 800.0, "y" => 450.0 }
            ],
           "land_type" => {
             "name" => "forest",
             "conquest_points" => 2,
             "color" => "yellow"
           },
           "has_tribe" => nil,
           "id" => 1,
           "width" => 3,
           "height" => 3,
           "player_defense" => nil
          }
          ],
          "color" => nil
        }
      ],
      "turn_played" => [
        {
          "name" => "bob",
          "coins" => 5,
          "cardinal_point" => "North",
          "races" => [
          {
            "name" => "humans",
            "troops_number" => 5
          }
          ],
          "occupied_regions" => [
            {
            "coordinates" => [
              { "x" => 900.0, "y" => 450.0 },
              { "x" => 800.0, "y" => 450.0 }
            ],
           "land_type" => {
             "name" => "forest",
             "conquest_points" => 2,
             "color" => "yellow"
           },
           "has_tribe" => nil,
           "id" => 1,
           "width" => 3,
           "height" => 3,
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
    @region_1 = Region.new(
      [
        { "x"=>900.0, "y"=>450.0 },
        { "x"=>800.0, "y"=>450.0 }
      ], 3, 3, 1)
    @region_1.land_type = LandType.new(
      "forest",
      2,
      "yellow"
    )
    @map = Map.new([@region_1], 6, 5, 1000)
    @game_master = GameMaster.new(GameState.new)
    @game_master.create_players([ "bob" ])
    @game_master.game_state.raceboard.races = [ Race.new("golems", 5) ]
    @game_master.game_state.raceboard.race_choices = [
      [ Race.new("dragons", 5), 0 ],
      [ Race.new("elves", 5), 0 ]
    ]
    @game_master.game_state.map = @map
    @game_master.game_state.rising_id = 1423065615.304268
    @players = @game_master.game_state.players
    @player = @game_master.game_state.players.first 
    @player.races = [Race.new("humans", 5)].to_set
    @player.occupied_regions = [@region_1].to_set
    @turn_tracker = TurnTracker.new(10, @players)
    @game_master.game_state.turn_tracker = @turn_tracker
    @game_master.game_state.turn_tracker.turn_played << @player
  end 

end
