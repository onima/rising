require 'services/game_master_service.rb'
require 'mongo'
include Mongo 

class TestGameMasterService < MiniTest::Unit::TestCase
  
  def setup
    setup!
  end

  def test_if_insert_method_create_database_with_collection_and_document
    delete_orgiac_db
    assert_equal [
      "local",
      "admin"
    ], @game_master_service.mongo_client.database_names
    @game_master_service.insert(@doc_1)
    assert_equal [
      "local",
      "orgiac_db",
      "admin"
    ], @game_master_service.mongo_client.database_names
    assert_equal [
      "orgiac_coll",
      "system.indexes"
    ], @database.collection_names
    assert_equal @database['orgiac_coll'].count, 1 
    delete_orgiac_db
  end

  def test_if_find_by_id_method_find_the_good_id
    delete_orgiac_db
    @game_master_service.insert(@doc_1)
    @game_master_service.insert(@doc_2)
    assert_equal 1422978712.8383105,
      @game_master_service.find_by_id(@orgiac_id).fetch("orgiac_id")
    delete_orgiac_db
  end

  def test_if_update_method_update_a_document
    delete_orgiac_db
    @game_master_service.insert(@doc_1)
    @game_master_service.update(@doc_1, @doc_3)
    assert_equal "kerrigan",
      @game_master_service.find_by_id(@orgiac_id).fetch("name")
    delete_orgiac_db
  end

  private

  def delete_orgiac_db
    @game_master_service.mongo_client.drop_database('orgiac_db')
  end

  def setup!
    @game_master_service = GameMasterService.new
    @database = @game_master_service.mongo_client['orgiac_db']
    @orgiac_id = 1422978712.8383105
    @doc_1 = {
      "name" => "mongo",
      "race" => "db",
      "orgiac_id" => 1422978712.8383105
    }
    @doc_2 = {
      "name" => "bobby"
    }
    @doc_3 = {
      "name" => "kerrigan",
      "race" => "zerg",
      "orgiac_id" => 1422978712.8383105
    }
  end

end
