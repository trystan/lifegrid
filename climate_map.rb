require 'perlin'

class ClimateMap
  def initialize width, height
    @short_cycle_length  = Math::PI * 2 * 1.0 / 100
    @medium_cycle_length = @short_cycle_length * 1.0 / 11
    @long_cycle_length   = @medium_cycle_length * 1.0 / 23

    @noise_maker = Perlin::Generator.new 1, 1.5, 1
    @ticks = 0

    @climate_map = @noise_maker.chunk 1, 1, 200, 200, 0.02
  end

  def [] *coords
    base = (@climate_map[coords[0]][coords[1]] + 1.0) * 4.5
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
    0.66 * Math::sin(@ticks * @short_cycle_length)
  end
  
  def medium_cycle
    1.0 * Math::sin(@ticks * @medium_cycle_length)
  end
  
  def long_cycle
    1.33 * Math::sin(@ticks * @long_cycle_length)
  end


  def clamp amount
    [[0, amount].max, 8].min.to_i
  end
end