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
  attr_reader :cols, :rows, :cursor
  attr_accessor :lines

  NTERMS = [10.chr, 13.chr]

  def initialize(cols=32, rows=20, current_row=0, lines="")
    @cols = cols
    @rows = rows
    @lines = lines  # string
    @cursor = Cursor.new(0, 0)
  end

  def display

    system("clear")
    puts "#".black * (cols + 2)

    lns = @lines.split("\n")
    nextline = true

    ln = ""

    @rows.times do |row|
      print "#"
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

        if row == @cursor.row && col == @cursor.col
          print @cursor
        elsif c.nil?
          nextline = true
          last_col = col
          break
        else
          print c
        end

      end
      (newcols - last_col).times do |col|
        if row == @cursor.row && (col + last_col) == @cursor.col
          print @cursor
        else
          print '.'
        end
      end

      puts "#"
    end
    puts "#".black * (cols + 2)
  end

  def move_left;     @cursor.col = (@cursor.col <= 1 ? 0 : @cursor.col - 1) end
  def move_right;    @cursor.col = (@cursor.col >= cols - 1 ? cols - 1 : @cursor.col + 1) end
  def move_up;       @cursor.row = (@cursor.row <= 1 ? 0 : @cursor.row - 1) end
  def move_down;     @cursor.row = (@cursor.row >= rows - 1 ? rows - 1 : @cursor.row + 1) end


end