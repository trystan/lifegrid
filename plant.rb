
class Plant
  attr_reader :x, :y, :color, :preferred_climate

  def alive?
    @energy > 0 && @age < 100
  end

  def initialize map, population, parent=nil
    if parent
      @x = [[0, parent.x + rand(11) - 5].max, 199].min
      @y = [[0, parent.y + rand(11) - 5].max, 199].min
      @color = parent.color.clone
      @preferred_climate = parent.preferred_climate
      @energy = 30
      @age = 1
    else
      @x = rand(200)
      @y = rand(200)
      @color = [0,0,0]
      @preferred_climate = rand(9)
      @energy = rand(50) + 25
      @age = rand(50)
    end
    @climate_map = map
    @population = population
  end

  def update
    @age += 1

    if @climate_map[x, y] == preferred_climate
      @energy += 10
    else
      @energy -= 10
    end

    if @energy >= 100
      birth
    end

    if !alive?
      die
    end
  end

  def birth
    @energy -= 40

    child = Plant.new(@climate_map, @population, self)

    if @population.select {|p| p.x == child.x && p.y == child.y }.length
      @population.push child
    end
  end

  def die
    @population.delete self
  end
end