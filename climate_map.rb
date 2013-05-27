require 'perlin_noise'

class ClimateMap
  def initialize width, height
    @noise_maker = Perlin::Noise.new 2
    @climate_map = Array.new(width) { Array.new(height) { 127 } }

    (0 .. width-1).each do |x|
      (0 .. height-1).each do |y|
        @climate_map[x][y] = [[0, @noise_maker[x * 0.033, y * 0.033] * 250.0 / 29.0].max, 9].min.to_i
      end
    end
  end

  def [] *coords
    @climate_map[coords[0]][coords[1]]
  end
end