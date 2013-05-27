require 'perlin_noise'
require 'rubygame'

class Game
  def initialize
    @screen = Rubygame::Screen.new [600,600], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
    @screen.title = "lifegrid"

    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 30

    @climate_map = Perlin::Noise.new 2
  end
  
  def run
    draw
    loop do
      update
      #draw
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
    (0 .. 200).each do |x|
      (0 .. 200).each do |y|
        climate = @climate_map[x * 0.01, y * 0.01] * 250
        @screen.fill [climate, climate, climate], Rubygame::Rect.new(x * 3, y * 3, 3, 3)
      end
    end

    @screen.update
  end
end

game = Game.new
game.run