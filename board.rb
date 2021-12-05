require_relative "cell"
require "byebug"

class Board
    def initialize(size)
        @grid = Array.new(size) { Array.new(size) { Cell.new } }
    end

    def [](pos)
        y, x = pos

        @grid[y][x]
    end

    def add_mines
        count = @grid.size
        mine_locs = []

        while mine_locs.length < count
            idxs = (0...count).to_a
            loc = []

            2.times { loc << idxs.sample }

            mine_locs << loc unless mine_locs.include?(loc)
        end

        mine_locs.each { |cell| self[cell].add_mine }
    end

    def render
        @grid.each do |row|
            cells = row.map { |cell| cell.render_value }
            puts cells.join(" ")
        end
    end

    def make_move(pos=self.get_input)
        cell_reveal = self[pos].reveal

        unless cell_reveal
            puts "That cell is already revealed."
            return false
        end

        true
    end

    def get_input
        puts "\nChoose a cell to reveal. Format as Row,Col (e.g. 1,4)"

        input = gets.chomp
        pos = self.parse_input(input)

        while !self.valid_cell?(pos)
            puts "\nThat cell position isn't valid. Please try again."
            pos = self.get_input
        end

        pos
    end

    def parse_input(input)
        pos_str_arr = input.split(",")

        pos_str_arr.map(&:to_i)
    end

    def valid_cell?(pos)
        idxs = (0...@grid.length).to_a
        y, x = pos
        
        idxs.include?(y) && idxs.include?(x)
    end

    def game_lost?
        @grid.any? do |row|
            row.any? { |cell| cell.revealed_mine? }
        end
    end
end

board = Board.new(9)
board.add_mines
board.render
board.make_move
p board.game_lost?