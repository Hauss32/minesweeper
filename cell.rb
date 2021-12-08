class Cell
    attr_reader :is_mine, :is_hidden

    def initialize
        @is_hidden = true
        @is_mine = false
        @count_mines_nearby = nil
        @is_flagged = false
    end

    def set_mines_count(num)
        @count_mines_nearby = num if num > 0
        self.reveal unless @is_mine || !is_hidden
    end

    def render_value
        return '⚠︎' if @is_flagged
        return '🀆' if @is_hidden
        return '✘' if self.revealed_mine?
        return @count_mines_nearby.to_s if @count_mines_nearby

        return ' '
    end

    def revealed_mine?
        return true if !@is_hidden && @is_mine

        false
    end

    def empty?
        @is_hidden && @count_mines_nearby.nil?
    end

    def toggle_flag
        if !@is_hidden
            puts "Looks like this cell is already revealed."
            return false
        else
            @is_flagged = !@is_flagged
        end
    end

    def add_mine
        @is_mine = true
    end

    def reveal
        if !@is_hidden
            puts "\n--- Alert ---"
            puts "That cell has already been revealed."
            return false
        elsif @is_flagged
            puts "\n--- Alert ---"
            puts "You've flagged this cell, so it is protected."
            return false
        else
            @is_hidden = false

            return true
        end
    end
end