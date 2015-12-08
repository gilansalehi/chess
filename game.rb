require_relative 'board.rb'
require_relative 'piece.rb'
require_relative 'display'

class Game

  attr_accessor :current_player

  def initialize
    @board = Board.new
    @current_player = :white
    # game log, load pieces, etc.?
  end

  def play
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
