require 'yaml'
require 'models/land_type.rb'

class GameState
  RULES_PATH = File.expand_path('rules.yml', File.dirname(__FILE__))
  RULES      = YAML.load_file(RULES_PATH)
  LAND_TYPES = RULES.fetch("land_types").map do |land_type|
    LandType.new(
      land_type.fetch("name"),
      land_type.fetch("conquest_points"),
      land_type.fetch("color"),
      land_type["status_point"]
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
      player_without_races = true if player.race.empty?
    end
    player_without_races
  end

  def turn_tracker_generate
    @turn_tracker = TurnTracker.new(10, @players)
  end

  def game_end?(actual_player_name)
    turn_tracker.turns_left == 1 && @players[1].name == actual_player_name
  end

  def update(player, turn_before_update)
    update_turn_tracker(player)
    update_troops_number(player)
    if turn_tracker.actual_turn != turn_before_update
      assign_status_and_points_to_regions
    end
  end

  private

  def map_generate
    @map = Map.new
  end

  def initialize_rising_id
    @rising_id = Time.now.to_f
  end

  def update_turn_tracker(player)
    turn_tracker.update(player)
  end

  def update_troops_number(player)
    player.race.first.troops_number = 5
  end

  def assign_status_and_points_to_regions
    affect_status_string_and_points
  end

  def affect_status_string_and_points
    map.regions.each do |region|
      regions_occupied.each do |region_occupied|
        region.land_type.affect_status if region.id == region_occupied.id
      end
      region.affect_rand_number if region.has_tribe
    end
  end

  def regions_occupied
    @players.map { |p| p.occupied_regions.to_a }.flatten!
  end
end
