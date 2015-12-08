class ChessError < StandardError
  def message
    puts "Illegal Move"
  end
end

class CheatyFace < ChessError
  def message
    puts "NOT YO TURN, CHEATA"
  end
end
