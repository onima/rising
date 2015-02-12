require 'sinatra'
require 'mongo'
require 'logger'
require 'config/game_state.rb'
require 'models/race.rb'
require 'models/raceboard.rb'
require 'models/player.rb'
require 'models/game_master.rb'
require 'models/map.rb'
require 'models/map_drawer.rb'
require 'models/turn_tracker.rb'
require 'models/land_type.rb'
require 'services/game_master_service.rb'
require 'serializer/serializer.rb'
require 'serializer/deserializer.rb'
require 'presenters/presenter.rb'
include Mongo

enable :sessions

logger = Logger.new(STDERR)

helpers do

  def serialize(object)
    Serializer.new.serialize_game_master_game_state(object)
  end

  def deserialize(hsh)
    Deserializer.new.deserialize_game_master_game_state(hsh)
  end

  def response_wrapper
    game_master_service = GameMasterService.new(
      'orgiac_db',
      'orgiac_coll'
    )
    orgiac_id = session[:orgiac_id]
    logger.info("Found orgiac id #{ orgiac_id }")
    game_master = game_master_service.generate_game_master_with_session_id(
      orgiac_id
    )
    logger.info("GameMaster deserialized => #{ game_master.inspect }")
    orgiac_id = game_master.game_state.orgiac_id
    yield game_master
    game_master_service.update(
                               { "orgiac_id" => orgiac_id }, serialize(game_master)
                              )
    logger.info("GameMaster serialized => #{ serialize(game_master) }")
    session[:orgiac_id] = orgiac_id
  end
end

get '/' do
  response_wrapper do |game_master_obj|
    @presenter = GamePresenter.new(game_master_obj)
  end
  erb :index
end

get '/players_choice' do
  response_wrapper do |game_master_obj|
    redirect to 'choose_race' if game_master_obj.game_state.players.any?
    if game_master_obj.game_state.raceboard.race_choices.empty?
      game_master_obj.game_state.raceboard.pick_active_races
    end
  end
  erb :players_choice
end

post '/create_players' do
  response_wrapper do |game_master_obj|
    players_names = params['players'].split(',').map(&:strip)
    game_master_obj.create_players(players_names)
  end
  redirect to 'choose_race'
end

get '/choose_race' do
  response_wrapper do |game_master_obj|
    @presenter = GamePresenter.new(game_master_obj)
    game_master_obj.assign_players_color(@presenter.players)
  end
  erb :race_choice
end

post '/choose_race' do
  response_wrapper do |game_master_obj|
    player_name = params["player"]
    race_name = params["race"]
    player = game_master_obj.game_state.players.find do |p|
      p.name == player_name
    end
    chosen_race = game_master_obj.game_state.raceboard.active_races.find do |r|
      r.name == race_name
    end
    game_master_obj.attribute_race(player, chosen_race)
  end
  redirect to 'choose_race'
end

get '/game' do
  response_wrapper do |game_master_obj|
    redirect to '/' if game_master_obj.game_state.raceboard.active_races.empty?
    redirect to '/' if game_master_obj.game_state.players.empty?
    @presenter = GamePresenter.new(game_master_obj)
    logger.info "Players are => #{ @presenter.players.map { |player| player.name } }"
  end
  erb :game
end

get '/play_turn' do
  response_wrapper do |game_master_obj|
    @presenter = GamePresenter.new(game_master_obj)
    logger.info "Players are => #{@presenter.players.map { |player| player.name } }"
    logger.info "Player who will play this turn is => #{ @presenter.player.name }"
  end
  erb :game
end

post '/play_turn' do

  response_wrapper do |game_master_obj|
    region_id = params["land"]
    player_string = params["name"]
    @presenter = GamePresenter.new(game_master_obj)
    logger.info "Region_id from params_land is =>  #{region_id}"
    logger.info "Player_string from params_name is =>  #{player_string}"
    # Need to be Correct
    player = game_master_obj.game_state.players.find do |p| 
      p.name == player_string
    end
    @presenter.player 
    logger.info "Show player_create with params => #{@presenter.player.inspect}"
    @presenter.players 

    if region_id
      region = game_master_obj.game_state.map.regions.find do |r|
        r.id == region_id.to_i
      end
      logger.info "Show region_created with region_id => #{region.inspect}"
      if region.occupied?(@presenter.players)
        logger.info "#{@presenter.player.name}_troops_number = #{@presenter.player.races[0].troops_number}"
        logger.info "Subtract player_troops_number with region_player_defense_number"
        player.races[0].troops_number -= region.player_defense
        logger.info "#{@presenter.player.name}_troops_number = #{@presenter.player.races[0].troops_number}"
      else
        logger.info "#{@presenter.player.name}_troops_number = #{@presenter.player.races[0].troops_number}"
        logger.info "Substract player_troops_number with region_neutral_defense"
        player.races[0].troops_number -= region.neutral_defense_points
        logger.info "#{@presenter.player.name}_troops_number = #{@presenter.player.races[0].troops_number}"
        region.player_defense = region.neutral_defense_points
      end
      player.occupied_regions << region
      logger.info "#{@presenter.player.name}' occupied_regions are => #{@presenter.player.occupied_regions.map {|occupied_region| p occupied_region.id}}"
    else
      logger.info "Region_id is nil so the game will update soon"
      logger.info "Turn_tracker before update => #{@presenter.turn_tracker.turn_played.map {|p| p.name}}"
      game_master_obj.game_state.turn_tracker.update(player)
      logger.info "Turn_tracker after update => #{@presenter.turn_tracker.turn_played.map { |p| p.name}}"
    end
  end
  redirect to '/play_turn'
end
