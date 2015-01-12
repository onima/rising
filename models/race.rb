class Race
  attr_reader :name
  attr_accessor :troops_number

  def initialize(name, troops_number)
    @name = name
    @troops_number = troops_number
  end
end
