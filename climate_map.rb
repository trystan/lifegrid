require 'perlin_noise'

class ClimateMap
  def initialize width, height
    @noise_maker = Perlin::Noise.new 2
    @climate_map = Array.new(width) { Array.new(height) { 127 } }
    @ticks = 0

    (0 .. width-1).each do |x|
      (0 .. height-1).each do |y|
        @climate_map[x][y] = @noise_maker[x * 0.033, y * 0.033] * 250.0
      end
    end
  end

  def [] *coords
    base = @climate_map[coords[0]][coords[1]]
    clamp adjust(base)
  end

  def update
    @ticks += 1
  end

  private

  def adjust amount
    amount + 20 * Math::sin(@ticks * 0.01)
  end

  def clamp amount
    [[0, amount / 29.0].max, 9].min.to_i
  end
end