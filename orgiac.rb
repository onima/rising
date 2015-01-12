require 'sinatra'
require './config/game_state.rb'
require './models/race.rb'
require './models/raceboard.rb'
require './models/player.rb'
require './models/game_master.rb'
require './models/map.rb'
require './models/map_drawer.rb'
require './models/turn_tracker.rb'

helpers do
  def game_state
    GameState.instance
  end

  def raceboard
    game_state.raceboard
  end

  def map
    game_state.map
  end

  def turn_tracker
    game_state.turn_tracker
  end

  def response_wrapper
    yield
  rescue RuntimeError, KeyError => e
    "There was an error parsing your request: #{e}"
  end
end

get '/' do
  response_wrapper do
    erb :index
  end
end

get '/players_choice' do
  response_wrapper do
    raceboard.pick_active_races
  end
  erb :players_choice
end

post '/create_players' do
  response_wrapper do
    players_names = params['players'].split(',').map(&:strip)
    GameMaster.new.create_players(players_names)

    #TODO error if no players names given
    redirect to '/choose_race'
  end
end

get '/choose_race' do
  @race_choices = raceboard.race_choices
  @active_races = raceboard.active_races
  @players = game_state.players
  GameMaster.new.assign_players_color(@players)
  erb :race_choice
end

post '/choose_race' do
  #TODO what happens if choose_race before choose players and choose active races?
  response_wrapper do
    player_name = params["player"]
    race_name = params["race"]
    player = game_state.players.find { |p| p.name == player_name }
    chosen_race = raceboard.active_races.find { |r| r.name == race_name }

    #TODO move check inside pick_race
    if player && player.can_pay_for_race?(chosen_race) && chosen_race
      raceboard.pick_race(chosen_race, player)
    end

    redirect to 'choose_race'
  end
end

get '/game' do
  #TODO make sure all players have chosen a race
  #if raceboard.active_races.empty? || game_state.players.empty?
  #  redirect to '/'
  #else
    @players = game_state.players
    game_state.map_generate
    map
    game_state.turn_tracker_generate
    turn_tracker
    @player = game_state.players.first
    erb :game
  #end
end

get '/play_turn' do
  @players = game_state.players
  map
  turn_tracker
  game_state.players.map.with_index do |player, index|
    @player = player if turn_tracker.turn_played.length == index
  end
   erb :game
end

post '/play_turn' do

  response_wrapper do
    region_id = params["land"]
    player_string = params["name"]
    player = game_state.players.find {|p| p.name == player_string}
    @player = player
    @players = game_state.players

    if region_id
    region = map.regions.find {|r| r.id == region_id.to_i}
    region.occupied?(@players) ? @player.races[0].troops_number -= region.player_defense : @player.races[0].troops_number -= region.neutral_defense_points && region.player_defense = region.neutral_defense_points
     @player.occupied_regions << region
    else
      turn_tracker.update(@player)
    end
  end
  redirect to 'play_turn'
end
