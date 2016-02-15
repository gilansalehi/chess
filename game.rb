require_relative 'board.rb'
require_relative 'piece.rb'
require_relative 'display'
require_relative 'computer.rb'

class Game

  attr_accessor :board, :display

  def initialize
    @board = Board.new
    # @current_player = "White"
    @display = Display.new(board)
    # game log, load pieces, etc.?
    @deep_blue = ComputerPlayer.new()
  end

  def play
    until board.checkmate?(:black) || board.checkmate?(:white)
      play_turn # MODIFY THIS SO COMPUTER MAKES MOVES FOR BLACK
      board.check_for_promotions
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
    # require current player to be the current player color
    # original_grid = board.grid.dup
    current = board.current_player.dup
    display.render
    if current == "white"
      until board.current_player != current
        puts "Current player is #{board.current_player}"
        display.get_input
        display.render
        # retry before switching players in case player enters an illegal move
      end
    else
      @deep_blue.play_move(board) # the computer will make moves as black.
      display.render
    end
  end

end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end
