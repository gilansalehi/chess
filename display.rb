require 'colorize'
require 'io/console'
require_relative 'Errors.rb'

class Display

  attr_accessor :board, :cursor, :selected, :grid, :start

  KEYMAP = {
    " " => :space,
    "w" => :up,
    "a" => :left,
    "s" => :down,
    "d" => :right,
    "\t" => :tab,
    "\r" => :return,
    "\n" => :newline,
    "\e" => :escape,
    "\e[A" => :up,
    "\e[B" => :down,
    "\e[C" => :right,
    "\e[D" => :left,
    "\177" => :backspace,
    "\004" => :delete,
    "\u0003" => :ctrl_c,
  }

  MOVES = {
    left: [0, -1],
    right: [0, 1],
    up: [-1, 0],
    down: [1, 0]
  }

  def initialize(board)
    @board = board
    @grid = board.grid
    @cursor = [0,0]
    @selected = false
  end

  def render
    system("clear")
    puts "Select a piece with Space Bar"

    grid.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        piece ||= " "
        background = bg(i,j)
        print " #{piece.to_s} ".colorize(background)
      end
      puts
    end
  end

  def bg(i,j)
    if [i,j] == cursor
      bg = :yellow
    elsif (i + j).odd?
      bg = :cyan
    else
      bg = :light_white
    end
    {background: bg}
  end

  def get_input
    key = KEYMAP[read_char]
    handle_key(key)
  rescue ChessError => e
    puts e.message
    @selected = false
    retry
  end

  def handle_key(key)
    case key
    when :ctrl_c
      exit 0
    when :space
      if selected == false && !board[cursor].nil?
        if board[cursor].color != board.current_player.to_sym
          raise CheatyFace
        end
        @selected = true
        @start = cursor
      elsif selected == true
        board.move(start, cursor)
        @selected = false
      end
    when :left, :right, :up, :down
      update_pos(MOVES[key])
    else
      puts key
    end

  end

  def read_char
    input = STDIN.getch
    input
  end

  def update_pos(diff)
    new_pos = [@cursor[0] + diff[0], @cursor[1] + diff[1]]
    @cursor = new_pos if in_bounds?(new_pos)
  end

  def in_bounds?(pos)
    pos.all? { |el| el < 8 && el >= 0 }
  end


end
