#JCOLEBOTS SNAKE
#Github link: https://gist.github.com/jcolebot/07d2657c86f015d4bbf08d23726559d7
#Retrieved 2025-03-25

require 'ruby2d'
#you can install Ruby 2D on WIN by entering "gem install ruby2d" in the terminal

set background: 'black'
set fps_cap: 10
#grid size is 20 pixels
SQUARE_SIZE = 20
#for default window size of 480px * 640px, width is 32 (640/20) and height is 24 (480/20) at grid size = 20 pixels
GRID_WIDTH = Window.width / SQUARE_SIZE
GRID_HEIGHT = Window.height / SQUARE_SIZE
#creating logic for the snake within a class
class Snake
  attr_writer :direction
#instance variables begin with @. uninitialized instance variables have the value nil
#first coordinate is x axis and second is y axis, starting from top left corner
  def initialize
    @positions = [[2, 0], [2, 1], [2, 2], [2 ,3]]
    @direction = 'down'
    @growing = false
  end

  def draw
    @positions.each do |position|
      Square.new(x: position[0] * SQUARE_SIZE, y: position[1] * SQUARE_SIZE, size: SQUARE_SIZE - 1, color: 'olive')
    end
  end

  def grow
    @growing = true
  end
#.shift moves all elements down by one
  def move
    if !@growing
      @positions.shift
    end

    @positions.push(next_position)
    @growing = false
  end
#prevents snake from moving backwards into itself
  def can_change_direction_to?(new_direction)
#case statement is a multibranch statement like switch statements in other languages. 
#makes it easy to execute different parts of the code based on a set value
    case @direction
    when 'up' then new_direction != 'down'
    when 'down' then new_direction != 'up'
    when 'left' then new_direction != 'right'
    when 'right' then new_direction != 'left'
    end
  end

  def x
    head[0]
  end

  def y
    head[1]
  end

  def next_position
    if @direction == 'down'
      new_coords(head[0], head[1] + 1)
    elsif @direction == 'up'
      new_coords(head[0], head[1] - 1)
    elsif @direction == 'left'
      new_coords(head[0] - 1, head[1])
    elsif @direction == 'right'
      new_coords(head[0] + 1, head[1])
    end
  end
#checks for snake collision with itself
  def hit_itself?
    @positions.uniq.length != @positions.length
  end

  private
#this method uses modulus to allow the snake 
#to pop onto the other side of the screen if it goes over the edge
  def new_coords(x, y)
    [x % GRID_WIDTH, y % GRID_HEIGHT]
  end
#.last returns last elements of self
  def head
    @positions.last
  end
end
#creating basic game mechanics
class Game
  attr_reader :score
  def initialize
    @ball_x = 10
    @ball_y = 10
    @score = 0
    @finished = false
  end

  def draw
    Square.new(x: @ball_x * SQUARE_SIZE, y: @ball_y * SQUARE_SIZE, size: SQUARE_SIZE, color: 'red')
    Text.new(text_message, color: 'white', x: 10, y: 10, size: 25, z: 1)
  end
#checks to see if snake touches ball
  def snake_hit_ball?(x, y)
    @ball_x == x && @ball_y == y
  end
#records when player hits ball
  def record_hit
    @score += 1
    @ball_x = rand(Window.width / SQUARE_SIZE)
    @ball_y = rand(Window.height / SQUARE_SIZE)
  end

  def finish
    @finished = true
  end

  def finished?
    @finished
  end

  private

  def text_message
    if finished?
      "Game over, Your Score was #{@score}. Press 'R' to continue. "
    else
      "Score: #{@score}"
    end
  end
end

snake = Snake.new
game = Game.new

update do
  clear

  unless game.finished?
    snake.move
  end

  snake.draw
  game.draw

  if game.snake_hit_ball?(snake.x, snake.y)
    game.record_hit
    snake.grow
  end

  if snake.hit_itself?
    game.finish
  end
end
#game loop logic
on :key_down do |event|
  if ['up', 'down', 'left', 'right'].include?(event.key)
    if snake.can_change_direction_to?(event.key)
      snake.direction = event.key
    end
  end

  if game.finished? && event.key == 'r'
    close
  end
end

# Start the Ruby2D window (this will keep it open and process events)
if __FILE__ == $0
  show
  puts game.score

end