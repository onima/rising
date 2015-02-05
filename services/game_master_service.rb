require 'mongo'

class GameMasterService

  attr_accessor :mongo_client

  def initialize(database_name, collection_name)
    @mongo_client = MongoClient.new("localhost", 27017)
    @mongo_client_db = database_name
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

  private

  def database
    @mongo_client.db(@mongo_client_db)
  end

  def collection
    database.collection(@mongo_client_coll)
  end
end 
