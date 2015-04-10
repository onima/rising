require 'sinatra'
require 'mongo'
require 'logger'
require 'json'
require 'config/game_state'
require 'models/race'
require 'models/raceboard'
require 'models/player'
require 'models/game_master'
require 'models/map'
require 'models/turn_tracker'
require 'models/land_type'
require 'services/game_master_service'
require 'serializer/serializer'
require 'serializer/deserializer'
require 'presenters/game'
require 'presenters/region'

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

  def display_player_troops_number
    "#{ @presenter.player.name }_troops_number = #{ @presenter.player.races.first.troops_number }"
  end

  def display_player_occupied_regions
    "#{ @presenter.player.name }' occupied_regions are => #{
      @presenter.player.occupied_regions.map do |occupied_region|
        p occupied_region.id
      end
    }"
  end

  def display_turn_tracker
    @presenter.turn_tracker.turn_played.map {|p| p.name}
  end

  def response_wrapper
    game_master_service = GameMasterService.new(
      'rising_db',
      'rising_coll'
    )
    rising_id = session[:rising_id]
    logger.info("Found orgiac id #{ rising_id }")
    game_master = game_master_service.generate_game_master_with_session_id(
      rising_id
    )
    logger.debug("GameMaster deserialized => #{ game_master.inspect }")
    rising_id = game_master.game_state.rising_id
    res = yield game_master
    game_master_service.update(
      { "rising_id" => rising_id }, serialize(game_master)
    )
    logger.debug("GameMaster serialized => #{ serialize(game_master) }")
    session[:rising_id] = rising_id
    res
  end
end

get '/' do
  response_wrapper do |game_master_obj|
    @presenter = Presenters::Game.new(game_master_obj)
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
    if game_master_obj.check_if_players_names_are_valid?(params['players'])
      players_names = params['players'].split
      game_master_obj.create_players(players_names)
    else
      redirect to 'players_choice'
    end
  end
  redirect to 'choose_race'
end

get '/choose_race' do
  response_wrapper do |game_master_obj|
    @presenter = Presenters::Game.new(game_master_obj)
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

get '/play_turn' do
  response_wrapper do |game_master_obj|
    redirect to '/' if game_master_obj.game_state.raceboard.active_races.empty?
    redirect to '/' if game_master_obj.game_state.players.empty?
    @presenter = Presenters::Game.new(game_master_obj)
    player = @presenter.player
    regions = @presenter.map.regions
    @conquerable_regions = Presenters::Region.conquerable_regions(
      player,
      regions
    )
    @owned_regions = Presenters::Region.owned_regions(
      player,
      regions
    )
    logger.info "Players are => #{
      @presenter.players.map(&:name)
    }"
    logger.info "Player who will play this turn is => #{
      @presenter.player.name
    }"
  end
  erb :game
end

post '/play_turn' do

  response_wrapper do |game_master_obj|
    region_id = params["land"]
    player_string = params["name"]
    @presenter = Presenters::Game.new(game_master_obj)
    logger.info "Region_id from params_land is =>  #{ region_id }"
    logger.info "Player_string from params_name is =>  #{ player_string }"
    player = game_master_obj.game_state.players.find do |p| 
      p.name == player_string
    end
    logger.info "Show player_create with params => #{
      @presenter.player.inspect
    }"
    if region_id
      region = game_master_obj.game_state.map.regions.find do |r|
        r.id == region_id
      end
      logger.info "Region_created with region_id => #{ region.inspect }"
      if region.occupied?(@presenter.players)
        logger.info display_player_troops_number
        logger.info "Subtract player_troops_number with region_player_defense_number"
        player.races.first.troops_number -= region.player_defense
        logger.info display_player_troops_number
      else
        logger.info display_player_troops_number
        logger.info "Substract player_troops_number with region_neutral_defense"
        player.races.first.troops_number -= region.neutral_defense_points
        logger.info display_player_troops_number
        region.player_defense = region.neutral_defense_points
      end
      player.occupied_regions << region
      logger.info display_player_occupied_regions
    else
      logger.info "Region_id is nil so the game will update soon"
      logger.info "Turn_tracker before update => #{display_turn_tracker}"
      game_master_obj.game_state.turn_tracker.update(player)
      logger.info "Turn_tracker after update => #{display_turn_tracker}"
    end
  end
  redirect to '/play_turn'
end

get '/regions_hsh' do
  response_wrapper do |game_master_obj|
    regions_hsh = Hash.new
    game_master_obj.game_state.map.regions.each do |region|
      regions_hsh[region.id] = Serializer.new.serialize_land_type(region.land_type)
    end
    content_type :json
    regions_hsh.to_json
  end
end

get '/conquerable_regions' do
  response_wrapper do |game_master_obj|
    @presenter = Presenters::Game.new(game_master_obj)
    player = @presenter.player
    regions = @presenter.map.regions
    @conquerable_regions = Presenters::Region.conquerable_regions(
      player,
      regions
    )
    @conquerable_regions_array = @conquerable_regions.map do |region|
      [region.id, region.defense_points]
    end
    content_type :json
    @conquerable_regions_array.to_json
  end
end
