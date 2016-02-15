require 'byebug'

class ComputerPlayer

  attr_accessor :board

  def intialize()
    @color = color
    @board = board
    @eval = 0 #score for white and for black
  end

  def pick_random_move(board)
    my_pieces = []
    puts(blind_eval(board))
    sleep(1)

    board.grid.flatten.compact.each do |square|
      my_pieces << square if square.color == :black
    end

    piece = my_pieces.shuffle.first

    until piece.valid_moves.length > 0
      piece = my_pieces.shuffle.first
    end

    start = piece.position
    fin = piece.valid_moves.shuffle.first
    return [start, fin]
  end

  def play_move(board)
    arr = pick_random_move(board) # Goal: replace this line with a more complex algorithm
    board.move(arr[0], arr[1])
  end

  def evaluate(board)
    if board.children
      vals = board.children.map { |child| child.eval }
      if board.current_player == "white"
        board.eval = vals.max # plus scores indicate good board states for white
      else
        board.eval = vals.min # minus indicates good board states for black, aka the computer
      end
    else
      board.eval = blind_eval(board)
    end
  end

  def blind_eval(board)
    # this method will assign a score to a board state without considering future moves
    white_score, black_score = 0, 0

    board.grid.flatten.compact.each do |square| #compact removes nil values
      square.color == :white ? white_score += square.value : black_score += square.value
    end

    return white_score - black_score
  end

  def calculate_move(board, depth)
    # board.valid_moves.each do |move|
    #   # make the move
    #   deep_board = board.deep_dup
    #   deep_board.move!(position, destination)
    #   deep_board.evaluate
    #   # make every response
    #   deep_board.valid_moves.each do |response|
    #     double_deep_board = board.deep_dup
    #     double_deep_board.move!(position, destination)
    #     double.deep_board.evaluate
    #   # evaluate the boards
    #   # recursively call calcluate_move at depth-1 on the four most promising moves.

    # end
  end

end
