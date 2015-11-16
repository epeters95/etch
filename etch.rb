require './board'

class Etch
  def initialize(speed=0.08)
    @speed = speed
  end

  def blank
    @board = Board.new()
    play
  end

  def play
    game_over = false
    i = 0
    @lastc = ''
    until game_over
      @board.display
      puts "cursor pos: #{@board.cursor_pos}"
      puts "cursor offset left: #{@board.distance_to_newline(@board.cursor_pos, :left)}"
      puts "cursor offset right: #{@board.distance_to_newline(@board.cursor_pos, :right)}"
      puts "last line size: #{@board.line_size}"

      @lastc = ''
      @lastc = get_char
      
      case @lastc
      when 'left'; @board.move_left
      when 'right'; @board.move_right
      when 'up'; @board.move_up
      when 'down'; @board.move_down

      when 127.chr
      # backspace
       
        placement = @board.cursor_pos - 1
        if placement > 0
          @board.lines.slice!(placement)
          @board.cursor_pos -= 1
        end
      else
        placement = @board.cursor_pos
        if @board.lines.size <= placement
          @board.lines += @lastc
        else
          @board.lines.insert(placement, @lastc)
        end
        @board.cursor_pos += 1
      end
      
      if @lastc == 'escape'
        game_over = true 
      end




    end
    system("clear")
  end

  def get_char
    state = `stty -g`
    `stty raw -echo -icanon isig`

    chr = ''
    if (chr = STDIN.sysread(3)) && chr[0] == 27.chr
      case chr[2]
      when 'D'
        chr = 'left'
      when 'C'
        chr = 'right'
      when 'A'
        chr = 'up'
      when 'B'
        chr = 'down'
      when nil
        chr = 'escape'
      else
        chr = 'nowhere man'
      end
    elsif [10, 13].include? chr[0].ord
      chr = "\n"
    end
    chr
  ensure
    `stty #{state}`
  end

end

Etch.new.blank