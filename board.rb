require_relative 'display'
require_relative 'piece'
require 'colorize'
require_relative 'Errors.rb'

class Board
  attr_accessor :grid, :current_player

  def initialize
    @grid = Array.new(8) { Array.new(8) }
    @current_player = "white"
    @eval = 0 # this instance variable is for the computer to calculate optimal moves
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

  def move!(start, fin)
    # raise "no piece there" if self[start].nil?
    # raise "invalid move" if #it's an invalid move!
    # selected_piece = self[start]
    selected_piece = self[start]
    self[start] = nil
    self[fin] = selected_piece
    selected_piece.position = fin
  end

  def move(start, fin)
    selected_piece = self[start]

    if selected_piece.valid_moves.include?(fin)
      self[start] = nil
      self[fin] = selected_piece
      selected_piece.position = fin
      switch_player
    else
      raise ChessError
    end
  end

  def switch_player
    if current_player == "white"
      @current_player = "black"
    elsif current_player == "black"
      @current_player = "white"
    end
  end


  def in_check?(color)
    # finds position of the King of the given color
    pos = nil
    grid.flatten.each do |square|
      pos = square.position if square.is_a?(King) && square.color == color
    end

    #checks legal moves of enemy pieces to see if they contain the King's pos.
    grid.flatten.compact.any? do |square|
      return true if square.color != color && square.moves.include?(pos)
    end
    false
  end

  def checkmate?(color)
    # checks each square for legal moves.  If none have legal moves, returns true
    grid.flatten.compact.none? do |square|
      square.color == color && (square.valid_moves.count > 0)
    end
  end

  # def valid_moves(color)
  #   legal_moves = {}
  #   grid.flatten.compact.each do |square|
  #     if square.color == color && (square.valid_moves.count > 0)
  #       legal_moves[square.position] = square.valid_moves
  #     end
  #   end
  #   legal_moves
  # end

  def deep_dup
    duped_board = Board.new
    (0..7).each do |row|
      (0..7).each do |col|
        square = self[[row, col]]
        if square.nil?
          duped_board[[row, col]] = nil
          next
        end
        color = square.color
        piece = square.class.new(color, [row,col], duped_board)
        duped_board[[row, col]] = piece
      end
    end
    duped_board
  end

  def populate_board
    row_of_pieces(0, :black)
    row_of_pieces(7, :white)
    # setup black's back row
    grid[1].each_index do |i| # changed from each_with_index
      grid[1][i] = BlackPawn.new(:black, [1,i], self) # and position
    end
    grid[6].each_index do |i|
      grid[6][i] = WhitePawn.new(:white, [6, i], self) # and position
    end
  end

  def row_of_pieces(row, color)
    grid[row][0] = Rook.new(color, [row, 0], self)
    grid[row][1] = Knight.new(color, [row, 1], self)
    grid[row][2] = Bishop.new(color, [row, 2], self)
    grid[row][3] = Queen.new(color, [row, 3], self)
    grid[row][4] = King.new(color, [row, 4], self)
    grid[row][5] = Bishop.new(color, [row, 5], self)
    grid[row][6] = Knight.new(color, [row, 6], self)
    grid[row][7] = Rook.new(color, [row, 7], self)
  end
end
