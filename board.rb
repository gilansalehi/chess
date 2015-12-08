require_relative 'display'
require_relative 'piece'


class Board
  attr_accessor :grid

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
    row_of_pieces(0, :black)
    row_of_pieces(7, :white)
    # setup black's back row
    grid[1].each_index do |i| # changed from each_with_index
      grid[1][i] = BlackPawn.new(:p, :black, [1,i], self) # and position
    end
    grid[6].each_index do |i|
      grid[6][i] = WhitePawn.new(:p, :white, [6, i], self) # and position
    end
  end

  def row_of_pieces(row, color)
    grid[row][0] = Rook.new(:R, color, [row, 0], self)
    grid[row][1] = Knight.new(:N, color, [row, 1], self)
    grid[row][2] = Bishop.new(:B, color, [row, 2], self)
    grid[row][3] = Queen.new(:Q, color, [row, 3], self)
    grid[row][4] = King.new(:K, color, [row, 4], self)
    grid[row][5] = Bishop.new(:B, color, [row, 5], self)
    grid[row][6] = Knight.new(:N, color, [row, 6], self)
    grid[row][7] = Rook.new(:R, color, [row, 7], self)
  end
end

if __FILE__ == $PROGRAM_NAME
  board = Board.new()
  board.populate_board
  test = Display.new(board)
  #
  # board[[0,4]] = King.new(:K, :black, [0,4], board)
  # board[[0,1]] = Knight.new(:N, :black, [0,1], board)
  # board[[0,0]] = Rook.new(:R, :black, [0,0], board)
  # board[[0,2]] = Bishop.new(:B, :black, [0,2], board)
  # board[[0,3]] = Queen.new(:Q, :black, [0,3], board)
  # print "King #{board[[0,4]].moves}"
  # puts
  # print "Knight #{board[[0,1]].moves}"
  # puts
  # print "Rook #{board[[0,0]].moves}"
  # puts
  # print "Bishop #{board[[0,2]].moves}"
  # puts
  # print "Queen #{board[[0,3]].moves}"
  # board[[5,2]] = BlackPawn.new(:p, :black, [5,2], board)
  # board[[1,3]] = BlackPawn.new(:p, :black, [1,3], board)
  # board[[6,1]] = WhitePawn.new(:p, :white, [6,1], board)
  test.render

  board.grid.flatten.each do | square |
    puts "#{square.class} : #{square.moves}" unless square.nil?
  end

  # while true
  #   test.get_input
  #   test.render
  # end
end
