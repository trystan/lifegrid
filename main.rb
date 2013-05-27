require 'perlin_noise'
require 'rubygame'

class Game
  def initialize
    @screen = Rubygame::Screen.new [600,600], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
    @screen.title = "lifegrid"

    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 30

    @colors = [
        [128,  50, 00],
        [128,  60, 10],
        [128,  70, 20],
        [128,  80, 30],
        [128,  90, 40],
        [128, 100, 50],
        [128, 110, 60],
        [128, 120, 70],
        [128, 130, 80]
      ]

    @noise_maker = Perlin::Noise.new 2

    @climate_map = Array.new(200) { Array.new(200) { 127 } }

    (0 .. 199).each do |x|
      (0 .. 199).each do |y|
        @climate_map[x][y] = (@noise_maker[x * 0.033, y * 0.033] * 250.0 / 29.0).to_i
      end
    end
  end
  
  def run
    loop do
      update
      draw
      @clock.tick
    end
  end
  
  def update
    @queue.each do |ev|
      case ev
        when Rubygame::QuitEvent
          Rubygame.quit
          exit
      end
    end
  end
  
  def draw
    (0 .. 199).each do |x|
      (0 .. 199).each do |y|
        climate = @climate_map[x][y]
        @screen.fill color(climate), Rubygame::Rect.new(x * 3, y * 3, 3, 3)
      end
    end

    @screen.update
  end

  def color climate
    climate = [[0, climate].max, 9].min
    @colors[climate]
  end
end

game = Game.new
game.run