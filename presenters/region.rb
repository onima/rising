module Presenters
  class Region < Struct.new(:id, :defense_points)
    def self.conquerable_regions(player, regions)
      models = regions.select do |region|
        region.can_be_attacked?(player)
      end
      models.map do |model|
        defense_points = model.player_defense || model.neutral_defense_points
        new(model.id, defense_points)
      end
    end

    def self.owned_regions(player, regions)
      player.occupied_regions.map do |model|
        new(model.id, model.player_defense)
      end
    end
  end
end
