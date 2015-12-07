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
  test.render
  board[[0,4]] = King.new(:K, :black, [0,4], board)
  test.render
  board[[0,1]] = Knight.new(:N, :black, [0,1], board)
  print board[[0,4]].moves
  puts
  print board[[0,1]].moves

  # while true
  #   test.get_input
  #   test.render
  # end
end
