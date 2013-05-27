
class Plant
  attr_reader :x, :y, :color

  def initialize
    @x = rand(200)
    @y = rand(200)
    @color = [0,0,0]
  end
end