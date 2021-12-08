require_relative "board.rb"
require "yaml"

class Game
    def initialize
        @board = nil
        self.set_board
        @board.render
    end

    def set_board
        board_new_or_load = self.get_new_or_load

        if board_new_or_load == 'new'
            self.make_new_board
        else
            self.get_file_and_load_board
        end
    end

    def get_file_and_load_board
        puts "Please enter the name of the game file you'd like to load. (e.g. my-game-1)"

        input = gets.chomp.downcase

        begin
            board_yml = File.read(input)
            @board = YAML::load(board_yml)
        rescue
            puts "File not found. Please try again."
            self.get_file_and_load_board
        end

        true
    end

    def make_new_board
        puts "\nMaking a new board..."
        @board = Board.new

        true
    end

    def get_new_or_load
        puts "Welcome to Minesweeper! You can start a new game, or load a saved game."
        puts "Type 'load' to load a file, or 'new' to begin a new game."

        input = gets.chomp.downcase

        until input == 'load' || input == 'new' 
            puts "\nThat type of action isn't supported. Please try again."
            input = self.get_new_or_load
        end

        input
    end

    def play
        puts "-------------------------"
        puts "\nReady to play?! There are #{@grid.length} bombs. Good luck!\n"
        @board.render

        until @board.game_won?
            move = @board.make_move
            @board.render if move

            if @board.game_lost?
                @board.render
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
end

game = Game.new