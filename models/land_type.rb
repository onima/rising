class LandType
  attr_accessor :name, :conquest_points, :color, :status_point

  def initialize(name, conquest_points, color, status_point)
    @name = name
    @conquest_points = conquest_points
    @color = color
    @status_point = status_point
  end
  
  def affect_increase_or_decrease_str
    @status_point = 'decreasing' if maximum_reach?
    @status_point = 'increasing' if minimum_reach?
  end

  def maximum_reach?
    @conquest_points == 6
  end

  def minimum_reach?
    @conquest_points == 1
  end

end
