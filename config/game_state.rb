require 'yaml'
require 'models/land_type.rb'
require 'models/player.rb'
require 'models/raceboard.rb'

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

  attr_accessor :players, :raceboard, :races, :land_types, :map, :turn_tracker

  def initialize
    reset! 
  end

  def reset!
    @players   = []
    @raceboard = RaceBoard.new(RULES)
  end

  def map_generate
    @map = Map.new(5,6,400)
  end

  def turn_tracker_generate
    @turn_tracker = TurnTracker.new(10, @players)
  end
end
