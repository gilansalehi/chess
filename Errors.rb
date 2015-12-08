class ChessError < StandardError
  def message
    puts "Illegal Move"
  end
end
