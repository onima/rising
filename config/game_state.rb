require 'yaml'
require 'models/land_type.rb'

class GameState
  RULES_PATH = File.expand_path('rules.yml', File.dirname(__FILE__))
  RULES      = YAML.load_file(RULES_PATH)
  LAND_TYPES = RULES.fetch("land_types").map do |land_type|
    LandType.new(
      land_type.fetch("name"),
      land_type.fetch("conquest_points"),
      land_type.fetch("color")
    )
  end

  attr_accessor :players, :raceboard, :map, :turn_tracker, :orgiac_id

  def initialize
    reset!
  end

  def reset!
    @players   = []
    @raceboard = RaceBoard.new(RULES)
  end

  def initialize_map_turn_tracker_orgiac_id
    map_generate
    turn_tracker_generate
    initialize_orgiac_id
  end

  private

  def map_generate
    @map = MapDrawer.new.create_new_map(5, 6, 400)
  end

  def turn_tracker_generate
    @turn_tracker = TurnTracker.new(10, @players)
  end

  def initialize_orgiac_id
    @orgiac_id = Time.now.to_f
  end

end
