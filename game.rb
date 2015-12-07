require_relative 'board.rb'
require_relative 'piece.rb'

class Game

  attr_accessor

  def initialize
    @board = Board.new
    # game log, load pieces, etc.?
  end

  def play
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
