class Cell
    def initialize
        @is_hidden = true
        @is_mine = false
        @count_mines_nearby = nil
        @is_flagged = false
    end

    def render_value
        return '_' if @is_hidden
        return '⚠︎' if @is_flagged
        return @count_mines_nearby.to_s if @count_mines_nearby
    end

    def toggle_flag
        if !@is_hidden
            puts "Looks like this cell is already shown."
            return false
        else
            @is_flagged = !@is_flagged
        end
    end

    def add_mine
        @is_mine = true
    end
end