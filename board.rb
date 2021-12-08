require_relative "cell"
require "byebug"

class Board
    def initialize(size=9)
        @grid = Array.new(size) { Array.new(size) { Cell.new } }
        self.add_mines
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
        idxs = (0...@grid.length).to_a

        puts "\n  #{idxs.join(" ")}"
        idxs.each do |y_idx|
            cells = @grid[y_idx].map { |cell| cell.render_value }
            puts "#{y_idx.to_s} #{cells.join(" ")}"
        end

        puts "\n"
    end

    def play
        puts "-------------------------"
        puts "\nWelcome to Minesweeper! There are #{@grid.length} bombs. Good luck!\n"
        self.render

        until self.game_won?
            move = self.make_move
            self.render if move

            if self.game_lost?
                self.render
                puts "-------------"
                puts "✘ GAME OVER ✘"
                puts "-------------"
                
                return
            end
        end

        puts "~~~~~~~~~~~~~~"
        puts "  YOU WIN!!!  "
        puts "~~~~~~~~~~~~~~"
    end

    def make_move(move=self.get_move_type)
        pos = self.get_pos_input

        if move == 'f'
            return self[pos].toggle_flag
        end

        cell_reveal = self[pos].reveal

        return false unless cell_reveal

        self.set_nearby_cells(pos)

        true
    end

    def get_move_type
        puts "\nType the letter 'f' to flag a cell, or type the letter 'r' to reveal a cell."

        input = gets.chomp

        until input == 'f' || input == 'r' 
            puts "\nThat type of move isn't valid. Please try again."
            input = self.get_move_type
        end

        input
    end

    def get_pos_input
        puts "\nChoose a cell position. Format as Row,Col (e.g. 1,4)"

        input = gets.chomp
        pos = self.parse_pos_input(input)

        while !self.valid_cell?(pos)
            puts "\nThat cell position isn't valid. Please try again."
            pos = self.get_pos_input
        end

        pos
    end

    def parse_pos_input(input)
        pos_str_arr = input.split(",")

        pos_str_arr.map(&:to_i)
    end

    def set_nearby_cells(pos)
        adj_cells = self.get_valid_adj_cells(pos)
        adj_cells_hidden = adj_cells.select { |cell| self[cell].is_hidden}
        has_adj_cell_mine = adj_cells_hidden.any? { |cell| self[cell].is_mine }

        if has_adj_cell_mine
            nearby_mines = self.count_mines_nearby(pos)
            self[pos].set_mines_count(nearby_mines)
            return
        else
            adj_cells_hidden.each do |adj_cell|
                cell = self[adj_cell]
                nearby_mines = self.count_mines_nearby(adj_cell)
                cell.set_mines_count(nearby_mines)
                self.set_nearby_cells(adj_cell)
            end
        end
    end

    def count_mines_nearby(pos)
        adj_cells = self.get_valid_adj_cells(pos)
        mines_count = adj_cells.count { |cell| self[cell].is_mine }

        mines_count
    end

    def get_valid_adj_cells(pos)
        all_adj_cells = self.get_all_adj_cells(pos)
        valids = all_adj_cells.select { |cell| self.valid_cell?(cell) }

        valids
    end

    def get_all_adj_cells(pos)
        y,x = pos
        adj_cells = []

        (y-1..y+1).to_a.each do |y_idx|
            row_cells = [y_idx].product((x-1..x+1).to_a)
            adj_cells += row_cells
        end

        adj_cells.delete(pos)

        adj_cells
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

    def game_won?
        total_mines = @grid.length
        count_hiddens = 0

        @grid.each do |row|
            row.each { |cell| count_hiddens += 1 if cell.is_hidden }
        end

        count_hiddens == total_mines
    end

    def test_show_mines
        mines = []

        (0...@grid.length).each do |y|
            (0...@grid.length).each { |x| mines << [y,x] if self[[y,x]].is_mine }
        end

        mines
    end
end

board = Board.new(9)
board.play
