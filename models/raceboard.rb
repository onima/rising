require './errors'
class RaceBoard
  attr_accessor :races

  def initialize(rules)
    @races = rules.fetch("races").map do |race|
      Race.new(
        race.fetch("name"),
        race.fetch("troops_number")
      )
    end
  end

  def pick_race(chosen_race, player)
    player.race << chosen_race
  end

end
