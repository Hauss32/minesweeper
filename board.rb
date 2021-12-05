require_relative "cell"

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
end

board = Board.new(9)
board.add_mines
board.render