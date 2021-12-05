class Cell
    attr_reader :is_mine
    def initialize
        @is_hidden = true
        @is_mine = false
        @count_mines_nearby = nil
        @is_flagged = false
    end

    def render_value
        # return "X" if @is_mine
        return '🀆' if @is_hidden
        return '⚠︎' if @is_flagged
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
        return false unless @is_hidden

        @is_hidden = false

        true
    end
end