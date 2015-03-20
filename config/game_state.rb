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

  attr_accessor :players, :raceboard, :map, :turn_tracker, :rising_id

  def initialize
    reset!
  end

  def reset!
    @players   = []
    @raceboard = RaceBoard.new(RULES)
  end

  def initialize_map_turn_tracker_rising_id
    map_generate
    turn_tracker_generate
    initialize_rising_id
  end

  def players_without_race?
    player_without_races = false
    @players.each do |player|
      player_without_races = true if player.races.empty?
    end
    player_without_races
  end

  private

  def map_generate
    @map = Map.new
  end

  def turn_tracker_generate
    @turn_tracker = TurnTracker.new(10, @players)
  end

  def initialize_rising_id
    @rising_id = Time.now.to_f
  end

end
