require 'colorize'

class Piece

  attr_accessor :symbol, :color

  def initialize(symbol, color)
    @symbol = symbol
    @color = color
  end

  def to_s
    case color
    when :black
      symbol.to_s.bold.black
    when :white
      symbol.to_s.bold.red
    end
  end

end
