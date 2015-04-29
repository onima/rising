require 'coveralls'
Coveralls.wear!
require 'minitest/autorun'
require 'models/land_type'

class TestLandType < MiniTest::Test

  def setup
    @land_type = LandType.new('hill', 2, '#FFD700', 'increasing')
  end

  def test_if_maximum_reach
    @land_type.conquest_points = 6
    assert @land_type.maximum_reach?
  end

  def test_if_minimum_reach
    @land_type.conquest_points = 1
    assert @land_type.minimum_reach?
  end

  def test_if_increase_str_is_affected
    @land_type.conquest_points = 6
    @land_type.affect_increase_or_decrease_str
    assert_equal 'decreasing', @land_type.status_point
  end

  def test_if_decrease_str_is_affected
    @land_type.conquest_points = 1
    @land_type.affect_increase_or_decrease_str
    assert_equal 'increasing', @land_type.status_point
  end

end
