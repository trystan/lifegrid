
require 'rubygame'
require_relative 'climate_map'
require_relative 'plant'

class Game
  def initialize map
    @screen = Rubygame::Screen.new [600,600], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
    @screen.title = "lifegrid"

    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 30

    @colors = make_colors

    @plants = Array.new(200) { Plant.new }

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

    @plants.each do |plant|
      @screen.set_at [plant.x * 3 + 1, plant.y * 3 + 1], plant.color
    end

    @screen.update
  end

  def color climate
    @colors[climate]
  end

  def make_colors
    colors = []
    (0..8).each do |i|
      c = Rubygame::Color::ColorHSV.new([0.1, 0.33, (i / 18.0 + 0.25)]).to_rgba_ary
      colors << [(c[0] * 255).to_i, (c[1] * 255).to_i, (c[2] * 255).to_i]
    end
    colors
  end
end


puts "Creating initial climate"
map = ClimateMap.new 200, 200
puts "Starting"
game = Game.new map
game.run


