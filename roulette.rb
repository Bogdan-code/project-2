require 'ruby2d'

# Configuration
WINDOW_WIDTH   = 600
WINDOW_HEIGHT  = 200
SEGMENT_COUNT  = 10
BLOCK_WIDTH    = WINDOW_WIDTH / SEGMENT_COUNT
BLOCK_HEIGHT   = 100
POINTER_Y1     = 40
POINTER_Y2     = 60
CENTER_INDEX   = SEGMENT_COUNT / 2  # fixed pointer position
@won = false
#─── 20-block base pattern: green at index 9, red/black alternating elsewhere ─────────
pattern_length = 20
green_index    = 9

base_pattern = Array.new(pattern_length) do |i|
  if i == green_index
    'green'
  elsif i < green_index
    i.even? ? 'red' : 'black'
  else
    i.odd? ? 'red' : 'black'
  end
end
# base_pattern now is:
# ["red","black","red","black","red","black","red","black","red","green",
#  "black","red","black","red","black","red","black","red","black","red"]

# Game state
state          = :waiting
guess          = nil
landing_color  = nil

# Deceleration timings
initial_interval = 0.05
max_interval     = 0.5
move_interval    = initial_interval
last_move_time   = Time.now.to_f

# Spin placeholders
spin_steps      = 0
spin_moves      = 0
top_upcoming    = []

# Initialize visible blocks from the base_pattern
t_pattern    = base_pattern.cycle
blocks       = []
block_colors = []
SEGMENT_COUNT.times do |i|
  col = t_pattern.next
  blocks << Rectangle.new(
    x:      i * BLOCK_WIDTH, y: 50,
    width:  BLOCK_WIDTH,     height: BLOCK_HEIGHT,
    color:  col
  )
  block_colors << col
end

# Draw fixed pointer
pointer_x = BLOCK_WIDTH * CENTER_INDEX + BLOCK_WIDTH/2
Triangle.new(
  x1: pointer_x,      y1: POINTER_Y1,
  x2: pointer_x - 10, y2: POINTER_Y2,
  x3: pointer_x + 10, y3: POINTER_Y2,
  color: 'white'
)

# Instruction and result text
instruction = Text.new(
  "Press R/B/G to spin", x: 5, y: 5,
  size: 20,              color: 'white'
)
result_text = Text.new(
  "",                    x: 5, y: 160,
  size: 20,              color: 'white'
)

on :key_down do |event|
  if state == :waiting
    # 1) record guess
    case event.key.downcase
    when 'r' then guess = 'red'
    when 'b' then guess = 'black'
    when 'g' then guess = 'green'
    else return
    end

    # 2) pick landing_color by 9/20:9/20:1/20
    weights = {'red'=>9, 'black'=>9, 'green'=>1}
    landing_color = weights.flat_map { |c,w| [c]*w }.sample

    # 3) choose random spin length (~4–7 s at ~0.05 s start)
    spin_steps = rand(25..60)
    spin_moves = 0

    # 4) build the exact scroll sequence—no two identical colors adjacent,
    #    one green every 20, and force the landing_color under the pointer
    total_needed  = SEGMENT_COUNT + spin_steps + CENTER_INDEX
    landing_index = spin_steps + CENTER_INDEX
    seq           = Array.new(total_needed)

    (0...total_needed).each do |i|
      if i == landing_index
        # force the weighted outcome
        seq[i] = landing_color
      elsif (i % pattern_length) == green_index
        # one green per 20
        seq[i] = 'green'
      else
        if i.zero?
          # start with red
          seq[i] = 'red'
        else
          # look at the last “real” color (skip green)
          prev = seq[i-1] == 'green' ? seq[i-2] : seq[i-1]
          seq[i] = (prev == 'red' ? 'black' : 'red')
        end
      end
    end

    # 5) populate the visible window & upcoming queue
    block_colors = seq[0, SEGMENT_COUNT]
    top_upcoming = seq[SEGMENT_COUNT, spin_steps]

    # 6) apply to on-screen rectangles
    blocks.each_with_index do |rect, i|
      rect.color = block_colors[i]
    end

    # 7) kick off the spin
    move_interval   = initial_interval
    last_move_time  = Time.now.to_f
    state           = :spinning
    instruction.text = "Spinning..."
  elsif state == :result
    close
  end
end

update do
  now = Time.now.to_f
  if state == :spinning && (now - last_move_time) >= move_interval
    # scroll left
    blocks.each { |r| r.x -= BLOCK_WIDTH }
    blocks.shift.remove
    block_colors.shift

    # bring in next block
    col = top_upcoming.shift
    blocks << Rectangle.new(
      x:      (SEGMENT_COUNT - 1) * BLOCK_WIDTH, y: 50,
      width:  BLOCK_WIDTH,                       height: BLOCK_HEIGHT,
      color:  col
    )
    block_colors << col

    spin_moves     += 1
    last_move_time  = now

    # quadratic ease-out deceleration
    progress       = spin_moves.to_f / spin_steps
    ease           = 1 - (1 - progress)**0.75
    move_interval  = initial_interval +
                     (max_interval - initial_interval) * ease

    # stop condition
    if spin_moves >= spin_steps
      state = :result
      landed = block_colors[CENTER_INDEX]
      @won    = (guess == landed)
      result_text.text = "Result: #{landed.capitalize}! " +
                         (@won ? "You won!" : "You lost!") +
                         " Score: #{@won ? 1 : 0}"
      instruction.text = "Press any key to exit"
    end
  end
end

if __FILE__ == $0
  show
  puts @won
end

