require 'sinatra'
require 'config/game_state.rb'
require 'models/race.rb'
require 'models/raceboard.rb'
require 'models/player.rb'
require 'models/game_master.rb'
require 'models/map.rb'
require 'models/map_drawer.rb'
require 'models/turn_tracker.rb'
require 'models/land_type.rb'
require 'serializer/serializer.rb'
require 'serializer/deserializer.rb'

enable :sessions

helpers do

  def serialize(object)
    Serializer.new.serialize_game_master_game_state(object)
  end

  def deserialize(hsh)
    Deserializer.new.deserialize_game_master_game_state(hsh)
  end

  def response_wrapper
    puts "----------------------BEFORE -----------------------"
    p session[:game_master]
    game_master =
      if session[:game_master]
        deserialize(session[:game_master])
      else
        session[:game_master] = GameMaster.new(GameState.new)
      end
    res = yield game_master # mutate insiste yield
    session[:game_master] = serialize(game_master)
    puts "----------------------AFTER -----------------------"
    p session[:game_master]
    res
  rescue RuntimeError, KeyError => e
    "There was an error parsing your request: #{e}"
  end
end

get '/' do
  response_wrapper do |game_master_obj|
  end
    erb :index
end

get '/players_choice' do
  response_wrapper do |game_master_obj|
    game_master_obj.game_state.raceboard.pick_active_races
  end
  erb :players_choice
end

post '/create_players' do
  response_wrapper do |game_master_obj|
    players_names = params['players'].split(',').map(&:strip)
    game_master_obj.create_players(players_names)
  end
  redirect to '/choose_race'
end

get '/choose_race' do
  response_wrapper do |game_master_obj|
    @race_choices = game_master_obj.game_state.raceboard.race_choices
    @active_races = game_master_obj.game_state.raceboard.active_races
    @players = game_master_obj.game_state.players
    game_master_obj.assign_players_color(@players)
  end
  erb :race_choice
end

post '/choose_race' do
  response_wrapper do |game_master_obj|
    player_name = params["player"]
    race_name = params["race"]
    player = game_master_obj.game_state.players.find { |p| p.name == player_name }
    chosen_race = game_master_obj.game_state.raceboard.active_races.find { |r| r.name == race_name }
    if player && player.can_pay_for_race?(chosen_race, game_master_obj.game_state) && chosen_race
      game_master_obj.game_state.raceboard.pick_race(chosen_race, player)
    end
  end
  redirect to 'choose_race'
end

get '/game' do
  response_wrapper do |game_master_obj|
    if game_master_obj.game_state.raceboard.active_races.empty? || game_master_obj.game_state.players.empty?
      redirect to '/'
    else
      @players = game_master_obj.game_state.players
      game_master_obj.game_state.map_generate
      @map = game_master_obj.game_state.map
      game_master_obj.game_state.turn_tracker_generate
      @turn_tracker = game_master_obj.game_state.turn_tracker
      @player = game_master_obj.game_state.players.first
      erb :game
    end
  end
end

#get '/game' do
  #TODO make sure all players have chosen a race
  #if raceboard.active_races.empty? || game_state.players.empty?
  #  redirect to '/'
  #else
#    @players = game_state.players
#    game_state.map_generate
#    map
#    game_state.turn_tracker_generate
#    turn_tracker
#   @player = game_state.players.first
#    erb :game
  #end
#end

#get '/play_turn' do
#  @players = game_state.players
#  map
#  turn_tracker
#  game_state.players.map.with_index do |player, index|
#    @player = player if turn_tracker.turn_played.length == index
#  end
#   erb :game
#end
#
#post '/play_turn' do
#
#  response_wrapper do
#    region_id = params["land"]
#    player_string = params["name"]
#    player = game_state.players.find {|p| p.name == player_string}
#    @player = player
#    @players = game_state.players
#
#    if region_id
#    region = map.regions.find {|r| r.id == region_id.to_i}
#    region.occupied?(@players) ? @player.races[0].troops_number -= region.player_defense : @player.races[0].troops_number -= region.neutral_defense_points && region.player_defense = region.neutral_defense_points
#     @player.occupied_regions << region
#    else
#      turn_tracker.update(@player)
#    end
#  end
#  redirect to 'play_turn'
#end
