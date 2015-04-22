require 'coveralls'
Coveralls.wear!
require 'minitest/autorun'
require 'services/game_master_service.rb'
require 'models/game_master.rb'
require 'serializer/serializer.rb'
require 'serializer/deserializer.rb'
require 'mongo'
include Mongo 

class TestGameMasterService < Minitest::Test
  
  def setup
    setup!
  end

  def test_if_insert_method_create_database_with_collection_and_document
    delete_test_app_db
    @game_master_service.insert(@doc_1)
    assert @game_master_service.mongo_client.database_names.include?("test_app_db")
    assert_equal 1, @database['test_app_coll'].count
    delete_test_app_db
  end

  def test_if_find_by_id_method_find_the_good_id
    delete_test_app_db
    @game_master_service.insert(@doc_1)
    @game_master_service.insert(@doc_2)
    assert_equal 1422978712.8383105,
      @game_master_service.find_by_id(@rising_id).fetch("rising_id")
    delete_test_app_db
  end

  def test_if_update_method_update_a_document
    delete_test_app_db
    @game_master_service.insert(@doc_1)
    @game_master_service.update(@doc_1, @doc_3)
    assert_equal "kerrigan",
      @game_master_service.find_by_id(@rising_id).fetch("name")
    delete_test_app_db
  end

  def test_if_method_generate_game_master_with_session_id_works
    delete_test_app_db
    @game_master_service.insert(@exp)
    g_m = @game_master_service.generate_game_master_with_session_id(1423065615.254268)
    assert_equal 1423065615.254268, g_m.game_state.rising_id
    delete_test_app_db
    @game_master_service.insert(@exp)
    g_m = @game_master_service.generate_game_master_with_session_id(nil)
    assert_equal "humans", g_m.game_state.raceboard.races[0].name
    delete_test_app_db
  end

  private

  def delete_test_app_db
    @game_master_service.mongo_client.drop_database('test_app_db')
  end

  def setup!
    @game_master_service = GameMasterService.new('test_app_db', 'test_app_coll')
    @database = @game_master_service.mongo_client['test_app_db']
    @rising_id = 1422978712.8383105
    @doc_1 = {
      "name" => "mongo",
      "race" => "db",
      "rising_id" => 1422978712.8383105
    }
    @doc_2 = {
      "name" => "bobby"
    }
    @doc_3 = {
      "name" => "kerrigan",
      "race" => "zerg",
      "rising_id" => 1422978712.8383105
    }
    @exp = {
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
             "color" => "yellow"
           },
           "has_tribe" => nil,
           "id" => "1,1",
           "columns" => 5,
           "rows" => 6,
           "coordinates" => [1, 1],
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
             "color" => "yellow"
           },
           "has_tribe" => nil,
           "id" => "1,1",
           "columns" => 5,
           "rows" => 6,
           "coordinates" => [1, 1],
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
             "color" => "yellow"
           },
           "has_tribe" => nil,
           "id" => "1,1",
           "columns" => 5,
           "rows" => 6,
           "coordinates" => [1, 1],
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
             "color" => "yellow"
           },
           "has_tribe" => nil,
           "id" => "1,1",
           "columns" => 5,
           "rows" => 6,
           "coordinates" => [1, 1],
           "player_defense" => nil
          }
          ],
          "color" => nil
        }
      ],
      "actual_turn" => 1
      },
      "rising_id" => 1423065615.254268
    }
  end
end
