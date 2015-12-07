


class Board
  attr_accessor :grid

  SETUP = [:R, :N, :B, :Q, :K, :B, :N, :R]

  def initialize
    @grid = Array.new(8) {Array.new(8)}
    populate_board
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
    raise "no piece there" if grid[start].nil?
    raise "invalid move" if #it's an invalid move!

    selected_piece = grid[start]
    grid[start] = nil
    grid[fin] = selected_piece
  end

  def populate_board
    # setup black's back row
    grid[0].each_index do |i| # changed from each_with_index
      grid[0,i] = Piece.new(SETUP[i], :black)
    end
    # setup the black pawns
    grid[1].each_index do |i|
      grid[1,i] = Piece.new(:P, :black)
    end
    # setup white pawns

    # setup white pieces

  end

end
