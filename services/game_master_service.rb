require 'mongo'

class GameMasterService

  MONGO_CLIENT_DB = "orgiac_db"
  MONGO_CLIENT_COLL = "orgiac_coll"

  attr_accessor :mongo_client

  def initialize
    @mongo_client = MongoClient.new("localhost", 27017)
  end

  def insert(doc)
    collection.insert(doc)
  end

  def find_by_id(id)
    collection.find(orgiac_id: id)
  end

  private

  def database
    @mongo_client.db(MONGO_CLIENT_DB)
  end

  def collection
    database.collection(MONGO_CLIENT_COLL)
  end
end 
