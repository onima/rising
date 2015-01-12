require 'singleton'
require './errors'

class RaceBoard
  ACTIVE_RACE_NUM = 6
  attr_accessor :races, :race_choices

  def initialize(rules)
    @races = rules.fetch("races").map do |race|
      Race.new(race.fetch("name"), race.fetch("troops_number"))
    end
    # race_choices is a an array of arrays. Each inside array contains a pair of [race, coins]. The race is the race object, the coins represent the amount of coins accumulated next to a race when a player skips it.
    @race_choices = []
  end

  def active_races
    @race_choices.map { |race_choice| race_choice.first }
  end

  def pick_active_races
    raise ActiveRacesAlreadyPicked if @race_choices.length == ACTIVE_RACE_NUM
    raise TooManyRacesRequired if @races.length < ACTIVE_RACE_NUM
    ACTIVE_RACE_NUM.times { add_race_choice }
  end

  def pick_race(chosen_race, player)
    index = active_races.index(chosen_race)
    raise RaceNotActive unless index
    raise NotEnoughRaces if @races.empty?

    race_index = active_races.index(chosen_race)
    @race_choices.each_with_index do |item, index|
      item[1] += 1 if index < race_index
    end

    player.pay(race_index)

    picked_race = @race_choices.find {|race, coins| chosen_race == race}
    chosen_race_coins = picked_race.last
    player.coins += chosen_race_coins
    player.races << chosen_race

    @race_choices.delete_at(index)
    add_race_choice
  end

  def add_race_choice
    new_race = @races.sample
    @race_choices.push([new_race, 0])
    @races.delete(new_race)
  end
end
