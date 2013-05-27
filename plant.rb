require_relative 'genotype'

class Plant
  attr_reader :x, :y, :genotype
  attr_accessor :energy

  def color
    @genotype.color
  end

  def growth
    @genotype.growth
  end

  def initialize map, population, parent=nil
    if parent
      @x = [[0, parent.x + rand(11) - 5].max, 199].min
      @y = [[0, parent.y + rand(11) - 5].max, 199].min
      @genotype = parent.genotype.clone
      @genotype.mutate
      @energy = 30
      @age = 1
    else
      @x = rand(200)
      @y = rand(200)
      @genotype = Genotype.new
      @energy = rand(50) + 25
      @age = rand(25)
    end
    @climate_map = map
    @population = population


    existing = population.at x, y
    if existing
      existing.energy -= 10
    else
      population.add self
    end
  end

  def update
    @age += 1

    @energy += growth[@climate_map[x, y]] - 1

    reproduce if @energy >= 100

    die if @energy < 1 || @age > 100
  end

  def reproduce
    @energy -= 40
    Plant.new @climate_map, @population, self
  end

  def die
    @population.delete self
  end
end