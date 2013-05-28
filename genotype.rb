
class Genotype
  attr_reader :color, :growth

  def initialize parent = nil
    if parent
      @color = parent.color.clone
      @growth = parent.growth.clone
    else
      @color = [rand(64)+32, rand(64)+32, rand(64)+32]
      @growth = Array.new(9) { 0 }
      9.times { @growth[rand(9)] += 1 }
    end
  end

  def clone
    Genotype.new self
  end

  def mutate
    @color[0] = [[32, @color[0] + rand(5) - 2].max, 64+32].min
    @color[1] = [[32, @color[1] + rand(5) - 2].max, 64+32].min
    @color[2] = [[32, @color[2] + rand(5) - 2].max, 64+32].min

    moved = false
    while !moved
      from = rand(9)
      to = rand(9)
      if @growth[from] > 0 && @growth[to] < 9
        @growth[from] -= 1
        @growth[to] += 1
        moved = true
      end
    end
  end
end