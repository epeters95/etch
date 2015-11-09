require './board'
require './cursor'

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

      @lastc = ''
      @lastc = get_char
      
      case @lastc
      when 'left'; @board.move_left
      when 'right'; @board.move_right
      when 'up'; @board.move_up
      when 'down'; @board.move_down
      else
        placement = @board.cursor.row * @board.cols + @board.cursor.col
        if @board.lines.size <= placement
          @board.lines += @lastc
        else
          @board.lines.insert(placement, @lastc)
        end
        if @board.cursor.col == @board.cols || [10, 13].include?(@lastc.ord)
          @board.cursor.row += 1
          @board.cursor.col = 0
        else
          @board.cursor.col += 1
        end
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