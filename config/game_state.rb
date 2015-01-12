require 'yaml'
require 'singleton'

class GameState
  include Singleton
  attr_accessor :players, :raceboard, :races, :land_types, :map, :turn_tracker

  def initialize
    reset!
  end

  def reset!
    rules_path = File.expand_path('rules.yml', File.dirname(__FILE__))
    @rules     = YAML.load_file(rules_path)
    @players   = []
    @raceboard = RaceBoard.new(@rules)
    @land_types = @rules.fetch("land_types").map do |land_type|
      LandType.new(land_type.fetch("name"), land_type.fetch("conquest_points"), land_type.fetch("color"))
    end
  end

  def map_generate
    @map = Map.new(5,6,400)
  end

  def turn_tracker_generate
    @turn_tracker = TurnTracker.new(10, @players)
  end

end
