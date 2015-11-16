# encoding: UTF-8 

require 'io/console'

class String
def black;          "\e[30m#{self}\e[0m" end
def red;            "\e[31m#{self}\e[0m" end
def green;          "\e[32m#{self}\e[0m" end
def brown;          "\e[33m#{self}\e[0m" end
def blue;           "\e[34m#{self}\e[0m" end
def magenta;        "\e[35m#{self}\e[0m" end
def cyan;           "\e[36m#{self}\e[0m" end
def gray;           "\e[37m#{self}\e[0m" end

def bg_black;       "\e[40m#{self}\e[0m" end
def bg_red;         "\e[41m#{self}\e[0m" end
def bg_green;       "\e[42m#{self}\e[0m" end
def bg_brown;       "\e[43m#{self}\e[0m" end
def bg_blue;        "\e[44m#{self}\e[0m" end
def bg_magenta;     "\e[45m#{self}\e[0m" end
def bg_cyan;        "\e[46m#{self}\e[0m" end
def bg_gray;        "\e[47m#{self}\e[0m" end

def bold;           "\e[1m#{self}\e[22m" end
def italic;         "\e[3m#{self}\e[23m" end
def underline;      "\e[4m#{self}\e[24m" end
def blink;          "\e[5m#{self}\e[25m" end
def reverse_color;  "\e[7m#{self}\e[27m" end
end

class Board
  attr_reader :cols, :rows, :line_size
  attr_accessor :lines, :cursor_pos

  NTERMS = [10.chr, 13.chr]

  def initialize(cols=32, rows=20, current_row=0, lines="")
    @cols = cols
    @rows = rows
    @lines = lines  # string
    @cursor_pos = 0
    @line_size = 0
    @cursor_char = '▒'
  end

  def display

    system("clear")
    puts "#".black * (cols + 2)

    lns = @lines.split("\n")
    nextline = true

    ln = ""
    pos = 0

    @rows.times do |row|
      print "#".black
      newcols = @cols
      if nextline
        nextline = false
        ln = lns.shift || ""
      else
        newcols -= 1
        print " "
      end

      last_col = newcols
      newcols.times do |col|
        c = ln.slice! 0

        if pos == @cursor_pos
          print @cursor_char
        elsif c.nil?
          nextline = true
          last_col = col
          pos += 1
          break
        else
          print c
        end

        pos += 1
      end
      (newcols - last_col).times do |col|
        print '.'.black
      end

      puts "#".black
    end
    puts "#".black * (cols + 2)
  end

  # Count the number of characters between start_pos and the next \n
  def distance_to_newline(start_pos, direction)
    dir = (direction == :left ? -1 : 1)
    i = start_pos + dir
    distance = 0

    while i.between?(0, @lines.size - 1) do
      break if ([10, 13].include? @lines[i].ord)
      distance += 1
      i += dir
    end
    distance + (direction == :right ? 1 : 0)
  end


  def move_left;     @cursor_pos -= 1 if (@cursor_pos > 0) end
  def move_right;    @cursor_pos += 1 if (@cursor_pos < @lines.size) end

  def move_up
    cursor_offset = distance_to_newline(@cursor_pos, :left)
    if @cursor_pos == cursor_offset
      @cursor_pos = 0
    else
      prev_line_size = @line_size = distance_to_newline(@cursor_pos - cursor_offset - 1, :left)
      if prev_line_size < cursor_offset
        @cursor_pos -= cursor_offset
      else
        @cursor_pos -= (prev_line_size + 1)
      end
    end
  end

  def move_down
    remaining = distance_to_newline(@cursor_pos, :right)
    if @cursor_pos + remaining == @lines.size - 1
      @cursor_pos = @lines.size - 1
    else
      cursor_offset = distance_to_newline(@cursor_pos, :left)
      next_line_size = @line_size = distance_to_newline(@cursor_pos + remaining, :left) + 1
      if next_line_size < cursor_offset
        @cursor_pos += remaining + next_line_size + 1
      else
        @cursor_pos += remaining + cursor_offset + 1
      end
    end
    @cursor_pos = @lines.size - 1 if @cursor_pos >= @lines.size
  end


end