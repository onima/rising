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

  def response_wrapper
    game_master_service = GameMasterService.new(
      'rising_db',
      'rising_coll'
    )
    rising_id           = session[:rising_id]
    logger.info("Found orgiac id #{ rising_id }")
    game_master         = game_master_service.generate_game_master_with_session_id(
      rising_id
    )
    logger.debug("GameMaster deserialized => #{ game_master.inspect }")
    rising_id           = game_master.game_state.rising_id
    res                 = yield game_master
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
  end
  erb :players_choice
end

post '/create_players' do
  response_wrapper do |game_master_obj|
    if game_master_obj.check_if_players_names_are_valid?(params['players'])
      players_names = params['players'].split
      game_master_obj.create_players(players_names)
      game_master_obj.game_state.turn_tracker_generate
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
    race_name   = params["race"]
    player      = game_master_obj.game_state.players.find do |p|
      p.name == player_name
    end
    chosen_race = game_master_obj.game_state.raceboard.races.find do |r|
      r.name == race_name
    end
    game_master_obj.attribute_race(player, chosen_race)
    game_master_obj.game_state.raceboard.races.delete(chosen_race)
  end
  redirect to 'choose_race'
end

get '/play_turn' do
  response_wrapper do |game_master_obj|
    redirect to '/' if game_master_obj.game_state.players.empty?
    @presenter = Presenters::Game.new(game_master_obj)

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
    player_name = params["player"]
    player      = game_master_obj.game_state.players.find do |p|
      p.name == player_name
    end
    logger.info "TurntrackerState before update => #{
      game_master_obj.game_state.turn_tracker.inspect
    }"
    game_master_obj.game_state.turn_tracker.update(player)
    logger.info "TurntrackerState after update => #{
      game_master_obj.game_state.turn_tracker.inspect
    }"
    player.race.first.troops_number = 5
  end
  redirect to 'play_turn'
end

post '/hexa_id_and_player_name' do
  response_wrapper do |game_master_obj|
    region_id   = params[:id]
    player_name = params[:name]
    @presenter  = Presenters::Game.new(game_master_obj)
    player      = game_master_obj.game_state.players.find do |p|
      p.name == player_name
    end

    if region_id
      region = game_master_obj.game_state.map.regions.find do |r|
        r.id == region_id
      end
      if region.occupied?(@presenter.players)
        player.race.first.troops_number -= region.player_defense
      else
        player.race.first.troops_number -= region.neutral_defense_points
        region.player_defense            = region.neutral_defense_points
      end
      player.occupied_regions << region
    else
      raise 'region_id is nil'
    end

    player_hsh = Serializer.new.serialize_player(player)
    content_type :json
    player_hsh.to_json
  end
end

get '/regions_hsh' do
  response_wrapper do |game_master_obj|
    presenter           = Presenters::Game.new(game_master_obj)
    player              = presenter.player
    players             = presenter.players
    regions_hsh         = Hash.new
    owned_regions       = Hash.new

    players.each do |gamer|
      gamer.occupied_regions.each do |region|
        owned_regions[region.id] = gamer.color
      end
    end

    game_master_obj.game_state.map.regions.each do |region|
      land_type_serialized               = Serializer.new.serialize_land_type(region.land_type)
      land_type_serialized["attackable"] = true if region.can_be_attacked?(player)
      if owned_regions.include?(region.id)
        land_type_serialized["occupied"]   = owned_regions.fetch(region.id)
      end
      regions_hsh[region.id]             = land_type_serialized
    end

    content_type :json
    regions_hsh.to_json
  end
end
