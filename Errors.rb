class ChessError < StandardError
  def message
    puts "Illegal Move"
  end
end

class CheatyFace < ChessError
  def message
    puts "That's not your piece"
  end
end
