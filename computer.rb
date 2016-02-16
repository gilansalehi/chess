require 'byebug'

class ComputerPlayer

  attr_accessor :board

  def intialize()
    @color = color
    @board = board
  end

  def play_move(board)
    puts("thinking...")
    board.children = []
    # pick a random move; then look for a better one?
    # min depth of 2 is required so it doesn't jeapordize it's own pieces.
    calculate_move(board, 1, 3) # populates and evaluates children of current position.

    arr = pick_best_move(board)

    board.move!(arr[0], arr[1])
    board.switch_player
  end

  def pick_best_move(board)
    vals = board.children.map { |child| child.eval }
    # min because negative scores are good for black
    best_pos = board.children.shuffle.select{ |child| child.eval == vals.min }
    debugger
    return best_pos[0].previous_move
  end

  def evaluate(board)
    if board.children.length > 0
      vals = board.children.map { |child| child.eval }
      # minmax tree search; assumes white makes best move
      board.current_player == "white" ? board.eval = vals.max : board.eval = vals.min
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

  def populate_children(board)
    board.legal_moves.each do |move|
      deep_board = board.deep_dup # copy the board

      position = move[0]
      destination = move[1]

      deep_board.capture = true unless destination.empty?
      deep_board.move!(position, destination) # make the move

      deep_board.previous_move = [position, destination] # store the move
      deep_board.switch_player
      # deep_board.check = true if deep_board.in_check?(deep_board.current_player) # takes too long?
      deep_board.eval = blind_eval(deep_board)
      board.children << deep_board
    end
  end

  def calculate_move(board, min_depth, max_depth)
    return blind_eval(board) if min_depth == 0 || max_depth == 0

    populate_children(board)

    board.children.each do |child|
      calculate_move(child, min_depth, max_depth - 1) if child.capture
      calculate_move(child, min_depth - 1, max_depth - 1) # non-check/captures

      evaluate(child)
    end
    evaluate(board) # necessary?
  end

end
