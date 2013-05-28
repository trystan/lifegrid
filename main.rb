
require 'rubygame'
require_relative 'climate_map'
require_relative 'plant'
require_relative 'population'

class Game
  def initialize
    @screen = Rubygame::Screen.new [600,600], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]

    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 30

    @ticks = 0
    @speed = 1
    @climate = ClimateMap.new 200, 200

    @colors = make_colors

    @plants = Population.new 200, 200
    200.times { Plant.new @climate, @plants }

    @draw_climate = true

    @background = Rubygame::Surface.new [600, 600]
    update_background

    update_title
  end

  def run
    @running = true
    while @running do
      @speed.times { update }
      puts "Population: #{@plants.size}\t\t#{@clock.framerate.round(2)}fps"
      events
      draw
      @clock.tick
    end
    Rubygame.quit
  end

  def update
    @ticks += 1
    update_climate if @ticks % 10 == 0
    @plants.array.each { |plant| plant.update }
  end

  def update_climate
    @climate.update
    update_background
  end

  def update_background
    return if !@draw_climate
    
    (0 .. 199).each do |x|
      (0 .. 199).each do |y|
        @background.fill @colors[@climate[x, y]], [x * 3, y * 3, 3, 3]
      end
    end
  end
  
  def events
    @queue.each do |event|
      case event
        when Rubygame::QuitEvent
          @running = false
        when Rubygame::KeyDownEvent
          if event.key == Rubygame::K_PLUS || event.key == Rubygame::K_EQUALS
            @speed += 1
            update_title
          elsif event.key == Rubygame::K_MINUS
            @speed = [@speed - 1, 0].max
            update_title
          elsif event.key == Rubygame::K_SPACE
            @draw_climate = !@draw_climate
            update_background
          end
      end
    end
  end

  def update_title
    @screen.title = "lifegrid"
    @screen.title += " (x#{@speed})" if @speed > 0
    @screen.title += " (paused)" if @speed == 0
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

  def make_colors
    colors = []
    (0..8).each do |i|
      c = Rubygame::Color::ColorHSV.new([0.1, 0.25, (i / 81.0 + 0.2)]).to_rgba_ary
      colors << [(c[0] * 255).to_i, (c[1] * 255).to_i, (c[2] * 255).to_i]
    end
    colors
  end
end

game = Game.new
game.run
