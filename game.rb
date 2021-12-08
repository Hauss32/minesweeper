require_relative "board.rb"
require "yaml"

class Game
    def initialize
        @board = nil
        self.set_board
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
            @board = YAML.load(board_yml)
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
        puts "\nReady to play?! There are 9 mines. Good luck!\n"
        @board.render

        until @board.game_won?
            move = self.make_move
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

    def make_move(move=self.get_move_type)
        pos = nil

        case move
        when 'r'
            pos = self.get_pos_input

            cell_reveal = @board[pos].reveal

            return false unless cell_reveal

            @board.set_nearby_cells(pos)

        when 'f'
            pos = self.get_pos_input

            return @board[pos].toggle_flag  
        when 's'
            self.save
        else
            puts "Unknown input: '#{move}'"

            return false
        end

        true
    end

    def get_move_type
        puts "\n----"
        puts "Type the letter 'r' to reveal a cell."
        puts "Type the letter 'f' to flag a cell."
        puts "Type the letter 's' to save the game."

        input = gets.chomp

        until input == 'f' || input == 'r' || input == 's'
            puts "\nThat type of action isn't supported. Please try again."
            input = self.get_move_type
        end

        input
    end

    def get_pos_input
        puts "\nChoose a cell position. Format as Row,Col (e.g. 1,4)"

        input = gets.chomp
        pos = self.parse_pos_input(input)

        while !@board.valid_cell?(pos)
            puts "\nThat cell position isn't valid. Please try again."
            pos = self.get_pos_input
        end

        pos
    end

    def parse_pos_input(input)
        pos_str_arr = input.split(",")

        pos_str_arr.map(&:to_i)
    end

    def save
        file_name = self.get_save_input

        File.open(file_name, "w") { |file| file.write(@board.to_yaml) }
    end

    def get_save_input
        puts "\nReady to save..."
        puts "What would you like to name the file?"

        file_name = gets.chomp
        puts "Ok! The game is saved to a file called #{file_name}"

        file_name += '.yml'


        file_name
    end
end

game = Game.new
game.play