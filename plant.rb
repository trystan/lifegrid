require_relative 'genotype'

class Plant
  attr_reader :x, :y, :genotype
  attr_accessor :energy

  def color
    @genotype.color
  end

  def initialize map, population, parent=nil
    if parent
      @x = [[0, parent.x + rand(7) + rand(7) - 6].max, 199].min
      @y = [[0, parent.y + rand(7) + rand(7) - 6].max, 199].min
      @genotype = parent.genotype.clone
      @genotype.mutate
    else
      @x = rand(200)
      @y = rand(200)
      @genotype = Genotype.new
    end
    @energy = 30
    @age = 1
    @climate_map = map
    @population = population
    update_population
  end

  def update_population
    existing = @population.at x, y
    if existing
      existing.energy -= 10
    else
      @population.add self
    end
  end

  def update
    @age += 1

    @energy += @genotype.growth[@climate_map[x, y]] - 1

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