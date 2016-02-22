require_relative 'board.rb'
require_relative 'pieces.rb'
require_relative 'display'

class Game

  attr_accessor :board, :display

  def initialize
    @board = Board.new
    @display = Display.new(board)
  end

  def play
    until board.checkmate?(:black) || board.checkmate?(:white)
      play_turn
    end
    if board.checkmate?(:black)
      puts "White wins!!"
      sleep(2)
    elsif board.checkmate?(:white)
      puts "Black wins!!"
      sleep(2)
    end
  end

  def play_turn
    current = board.current_player.dup
    display.render

    until board.current_player != current
      puts "Current player is #{board.current_player}"
      display.get_input
      display.render
    end

  end


end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
