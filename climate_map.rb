begin
  require 'perlin-123'

  NOISE = Perlin::Generator.new rand(1000), 1.5, 1
  def get_base_climate width, height, ticks
    NOISE.chunk 1, 1, ticks * 0.001, width, height, 1, 0.02
  end

rescue LoadError => e
  puts 'Gem "perlin" is not installed, trying gem "perlin_noise".'
  require 'perlin_noise'
  puts 'Using "perlin_noise". Install "perlin" gem for *vastly* better performance.'

  NOISE = Perlin::Noise.new 3
  def get_base_climate width, height, ticks
    Array.new(width) { |x| Array.new(height) { |y| Array.new(1) { |z| NOISE[x * 0.03, y * 0.03, ticks * 0.001] * 2.0 - 1 } } }
  end

end

class ClimateMap
  def initialize width, height
    @short_cycle_length  = Math::PI * 2 * 1.0 / 100
    @medium_cycle_length = @short_cycle_length * 1.0 / 11
    @long_cycle_length   = @medium_cycle_length * 1.0 / 23

    @ticks = 0
    @precalc_map = Array.new(width) { Array.new(height) { 0 } }

    make_base_map
  end

  def [] *coords
    @precalc_map[coords[0]][coords[1]]
  end

  def update
    @ticks += 1
    make_base_map
  end

  def make_base_map
    @climate_map = get_base_climate @precalc_map.length, @precalc_map[0].length, @ticks

    (0 .. 199).each do |x|
      (0 .. 199).each do |y|
        base = (@climate_map[x][y][0] + 1.0) * 4.5
        @precalc_map[x][y] = clamp adjust(base)
      end
    end
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