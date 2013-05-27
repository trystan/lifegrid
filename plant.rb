
class Plant
  attr_reader :x, :y, :color, :growth
  attr_accessor :energy

  def occupied_map
    @@occupied_map ||= Array.new(200) { Array.new(200) { nil } }
  end

  def initialize map, population, parent=nil
    if parent
      @x = [[0, parent.x + rand(11) - 5].max, 199].min
      @y = [[0, parent.y + rand(11) - 5].max, 199].min
      @color = parent.color.clone
      @growth = parent.growth.clone
      @energy = 30
      @age = 1
      mutate
    else
      @x = rand(200)
      @y = rand(200)
      @color = [rand(64)+32, rand(64)+32, rand(64)+32]
      @growth = Array.new(9) { 0 }
      9.times.each { @growth[rand(9)] += 1 }
      @energy = rand(50) + 25
      @age = rand(25)
      occupied_map[x][y] = self
    end
    @climate_map = map
    @population = population
  end

  def mutate
    @color[0] = [[32, @color[0] + rand(11) - 5].max, 64+32].min
    @color[1] = [[32, @color[1] + rand(11) - 5].max, 64+32].min
    @color[2] = [[32, @color[2] + rand(11) - 5].max, 64+32].min

    from = rand(9)
    to = rand(9)
    if @growth[from] > 0 && @growth[to] < 9
      @growth[from] -= 1
      @growth[to] += 1
    end
  end

  def update
    @age += 1

    @energy += growth[@climate_map[x, y]] - 1

    birth if @energy >= 100

    die if time_to_die?
  end

  def time_to_die?
    @energy < 1 || @age > 100
  end

  def birth
    @energy -= 40

    child = Plant.new(@climate_map, @population, self)

    if occupied_map[child.x][child.y]
      occupied_map[child.x][child.y].energy -= 10
    else
      @population.push child
      occupied_map[child.x][child.y] = child
    end
  end

  def die
    @population.delete self
    occupied_map[x][y] = nil
  end
end