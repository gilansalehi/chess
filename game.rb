require_relative 'board.rb'
require_relative 'piece.rb'
require_relative 'display'

class Game

  attr_accessor :board, :display

  def initialize
    @board = Board.new
    # @current_player = "White"
    @display = Display.new(board)
    # game log, load pieces, etc.?
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
    # require current player to be the current player color
    # original_grid = board.grid.dup
    current = board.current_player.dup
    display.render

    until board.current_player != current
      puts "Current player is #{board.current_player}"
      display.get_input
      display.render
      # retry before switching players in case player enters an illegal move
    end

  end


end

if __FILE__ == $PROGRAM_NAME
  game = Game.new
  game.play
end

#
# if __FILE__ == $PROGRAM_NAME
#   board = Board.new()
#   board.populate_board
#   test = Display.new(board)
#   test.render
#
#   while true
#     # test.get_input
#     test.render
#     board.grid.flatten.each do | square |
#       puts "#{square.class} vmoves: #{square.valid_moves}" unless square.nil?
#     end
#     test.get_input
#     if board.checkmate?(:black)
#       puts "white wins "
#       sleep(2)
#     elsif board.checkmate?(:white)
#       puts "black wins "
#       sleep(2)
#     end
#   end
#
#
# end
