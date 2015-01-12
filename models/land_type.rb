class LandType
  attr_reader :name, :conquest_points, :color

  def initialize(name, conquest_points, color)
    @name = name
    @conquest_points = conquest_points
    @color = color
  end
end
