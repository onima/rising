require 'coveralls'
Coveralls.wear!
require 'minitest/autorun'
require 'models/region'

class TestMap < Minitest::Test

  def setup
    @map = Map.new
    @map.regions = @map.create_id_regions(5,6)
  end

  def test_if_create_id_regions_method_assign_id_to_regions
    assert_equal [2, 5], @map.regions[10].id
  end
end
