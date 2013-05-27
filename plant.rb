
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
      mutate
    else
      @x = rand(200)
      @y = rand(200)
      @color = [rand(64)+32, rand(64)+32, rand(64)+32]
      @preferred_climate = rand(9)
      @energy = rand(50) + 25
      @age = rand(50)
    end
    @climate_map = map
    @population = population
  end

  def mutate
    @color[0] = [[32, @color[0] + rand(7) - 3].max, 64+32].min
    @color[1] = [[32, @color[1] + rand(7) - 3].max, 64+32].min
    @color[2] = [[32, @color[2] + rand(7) - 3].max, 64+32].min

    if rand(10) == 1
      @preferred_climate = rand(3) - 1
    end
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