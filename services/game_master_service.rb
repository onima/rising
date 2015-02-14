require 'mongo'
require 'models/game_master.rb'
require 'serializer/serializer.rb'
require 'serializer/deserializer.rb'

class GameMasterService

  attr_accessor :mongo_client

  def initialize(database_name, collection_name)
    if ENV['RACK_ENV'] == 'production'
      mongo_uri = ENV['MONGOLAB_URI']
      @mongo_client_db = mongo_uri[%r{/([^/\?]+)(\?|$)}, 1]
      @mongo_client = MongoClient.from_uri(mongo_uri)
    else
      @mongo_client = MongoClient.new("localhost", 27017)
      @mongo_client_db = database_name
    end
    @mongo_client_coll = collection_name
  end

  def insert(doc)
    collection.insert(doc)
  end

  def find_by_id(id)
    doc = collection.find("orgiac_id" => id).to_a
    doc[0]
  end

  def update(hsh_1, hsh_2)
    collection.update(hsh_1, hsh_2)
  end

  def generate_game_master_with_session_id(session_id)
    if session_id
      g_m_hsh = find_by_id(session_id)
      Deserializer.new.deserialize_game_master_game_state(g_m_hsh)
    else
      g_m = GameMaster.new(GameState.new)
      g_m.game_state.initialize_map_turn_tracker_orgiac_id
      insert(Serializer.new.serialize_game_master_game_state(g_m))
      g_m
    end
  end

  private

  def database
    @mongo_client.db(@mongo_client_db)
  end

  def collection
    database.collection(@mongo_client_coll)
  end

end 
