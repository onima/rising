require 'presenters/region'

module Presenters
  class RegionTest < MiniTest::Unit::TestCase
  end

  class ConquerableRegionsTest < RegionTest
    class FakeRegion < Struct.new(:id, :player_defense, :neutral_defense_points)
      def can_be_attacked?(player)
        case id
        when 1; false
        when 2; true
        when 3; true
        else raise "Behaviour not specified for region with id #{id}"
        end
      end
    end

    def setup
      player                 = Object.new
      not_attackable         = FakeRegion.new(1, 1, 1)
      with_player_defense    = FakeRegion.new(2, 2, 1)
      without_player_defense = FakeRegion.new(3, nil, 1)
      regions                = [
        not_attackable,
        with_player_defense,
        without_player_defense
      ]

      @attackable = Region.conquerable_regions(player, regions)
    end

    def test_non_attackable_regions_are_excluded
      refute(@attackable.map(&:id).include?(1))
    end

    def test_defended_by_player_show_player_defense_points
      assert_equal(2, @attackable.find { |r| r.id == 2}.defense_points)
    end

    def test_not_defended_by_player_show_neutral_points
      assert_equal(1, @attackable.find { |r| r.id == 3}.defense_points)
    end
  end
end
