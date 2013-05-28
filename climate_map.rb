require 'perlin_noise'

class ClimateMap
  def initialize width, height
    @short_cycle_length  = Math::PI * 2 * 1.0 / 100
    @medium_cycle_length = @short_cycle_length * 1.0 / 11
    @long_cycle_length   = @medium_cycle_length * 1.0 / 23

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

  def adjust amount
    amount + short_cycle + medium_cycle + long_cycle
  end

  private

  def short_cycle
    14 * Math::sin(@ticks * @short_cycle_length)
  end
  
  def medium_cycle
    14 * Math::sin(@ticks * @medium_cycle_length)
  end
  
  def long_cycle
    14 * Math::sin(@ticks * @long_cycle_length)
  end


  def clamp amount
    [[0, amount / 29.0].max, 9].min.to_i
  end
end