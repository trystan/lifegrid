
class Population
  attr_reader :array

  def initialize width, height
    @grid = Array.new(width) { Array.new(height) { nil } }
    @array = Array.new
  end

  def add agent
    @array.push agent
    @grid[agent.x][agent.y] = agent
  end

  def delete agent
    @array.delete agent
    @grid[agent.x][agent.y] = nil
  end

  def at x, y
    @grid[x][y]
  end

  def size
    @array.length
  end
end