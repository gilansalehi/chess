require_relative 'display'
require_relative 'piece'


class Board
  attr_accessor :grid

  SETUP = [:R, :N, :B, :Q, :K, :B, :N, :R]

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    # populate_board
  end

  def[](pos)
    row,col = pos
    grid[row][col]
  end

  def[]=(pos, mark)
    row,col = pos
    @grid[row][col] = mark
  end

  def move(start, fin)
    # raise "no piece there" if self[start].nil?
    # raise "invalid move" if #it's an invalid move!

    selected_piece = self[start]
    self[start] = nil
    self[fin] = selected_piece
  end

  def populate_board
    # setup black's back row
    grid[0].each_index do |i| # changed from each_with_index
      self[[0,i]] = Piece.new(SETUP[i], :black, [0,i], self) # and position
    end
    # setup the black pawns
  #  grid[1].each_index do |i|
  #    grid[1][i] = Piece.new(:p, :black) # and position
  #  end
    # setup white pawns
   grid[6].each_index do |i|
     grid[6][i] = Piece.new(:p, :white) # and position
   end
    # setup white pieces
   grid[7].each_index do |i| # changed from each_with_index
     grid[7][i] = Piece.new(SETUP[i], :white) # position
   end
  end

end

if __FILE__ == $PROGRAM_NAME
  board = Board.new()
  board.populate_board
  test = Display.new(board)

  board[[0,4]] = King.new(:K, :black, [0,4], board)
  board[[0,1]] = Knight.new(:N, :black, [0,1], board)
  board[[0,0]] = Rook.new(:R, :black, [0,0], board)
  board[[0,2]] = Bishop.new(:B, :black, [0,2], board)
  board[[0,3]] = Queen.new(:Q, :black, [0,3], board)
  print "King #{board[[0,4]].moves}"
  puts
  print "Knight #{board[[0,1]].moves}"
  puts
  print "Rook #{board[[0,0]].moves}"
  puts
  print "Bishop #{board[[0,2]].moves}"
  puts
  print "Queen #{board[[0,3]].moves}"
  board[[5,2]] = BlackPawn.new(:p, :black, [5,2], board)
  board[[1,3]] = BlackPawn.new(:p, :black, [1,3], board)
  board[[6,1]] = WhitePawn.new(:p, :white, [6,1], board)
  test.render
  print "Attack Pawn  #{board[[5,2]].moves}"
  puts
  print "Defense Pawn #{board[[1,3]].moves}"
  puts
  print "White Pawn #{board[[6,1]].moves}"
  puts
  # while true
  #   test.get_input
  #   test.render
  # end
end
