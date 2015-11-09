class Cursor
  attr_accessor :row, :col

  def initialize(col, row)  # display position
    @col = col
    @row = row
    @char = '▒'
  end

  def blink
    @char = (@char == '▒' ? ' ' : '▒')
  end

  def to_s
    @char
  end
end