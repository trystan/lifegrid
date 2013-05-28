
require 'rubygame'
require_relative 'climate_map'
require_relative 'plant'
require_relative 'population'

class Game
  def initialize map
    @screen = Rubygame::Screen.new [600,600], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
    @screen.title = "lifegrid"

    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 30
    @ticks = 0

    @colors = make_colors

    @plants = Population.new 200, 200
    (0..99).each { Plant.new(map, @plants) }

    @climate_map = map
    @draw_climate = true

    @background = Rubygame::Surface.new [600, 600]
    update_background
  end

  def update_background
    return if !@draw_climate

    (0 .. 199).each do |x|
      (0 .. 199).each do |y|
        @background.fill color(@climate_map[x, y]), [x * 3, y * 3, 3, 3]
      end
    end
  end

  def run
    @running = true
    while @running do
      update
      events
      draw
      @clock.tick
    end
    Rubygame.quit
  end

  def update
    @ticks += 1
    if @ticks % 10 == 0
      @climate_map.update
      update_background
    end

    @plants.array.each do |plant|
      plant.update
    end

    puts "Population: #{@plants.size}\t\t Climate: #{@climate_map.adjust(0)/28}"
  end
  
  def events
    @queue.each do |event|
      case event
        when Rubygame::QuitEvent
          @running = false
        when Rubygame::KeyDownEvent
          if event.key == Rubygame::K_SPACE
            @draw_climate = !@draw_climate
            update_background
          else
            puts event.key
          end
      end
    end
  end
  
  def draw
    if @draw_climate
      @background.blit @screen, [0,0]
    else
      @screen.fill [32,32,32]
    end

    @plants.array.each do |plant|
      @screen.fill plant.color, [plant.x * 3, plant.y * 3, 2, 2]
    end

    @screen.update
  end

  def color climate
    @colors[climate]
  end

  def make_colors
    colors = []
    (0..8).each do |i|
      c = Rubygame::Color::ColorHSV.new([0.1, 0.25, (i / 45.0 + 0.2)]).to_rgba_ary
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


