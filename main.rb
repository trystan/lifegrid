
require 'rubygame'
require_relative 'climate_map'

class Game
  def initialize map
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

    @climate_map = map
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
        @screen.fill color(@climate_map[x, y]), [x * 3, y * 3, 3, 3]
      end
    end

    @screen.update
  end

  def color climate
    @colors[climate]
  end
end

puts "Creating initial climate"
map = ClimateMap.new 200, 200
puts "Starting"
game = Game.new map
game.run
