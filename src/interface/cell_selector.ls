define [
    'interface/user_interface'
    'structures/direction'
    'types'
    'util'
], (UserInterface, Direction, Types, Util) ->

    class CellSelector
        ->
            @selectedPosition = void

        selectCell: (start_coord, character, game_state, cb, on_each) ->
            @selectedPosition = start_coord
            @selectCellLoop(character, game_state, cb, on_each)

        selectCellLoop: (character, game_state, cb, on_each) ->

            on_each?(@selectedPosition)

            [control, extra] <~ Util.repeatWhileUndefined(UserInterface.getControl)

            switch control.type
            |   Types.Control.NavigateToCell
                    cb(extra)
            |   Types.Control.Direction
                    change = Direction.Vectors[control.direction]
                    position = @selectedPosition.add(change)
                    if character.grid.isValidCart(position)
                        @selectedPosition = position
                    @selectCellLoop(character, game_state, cb, on_each)
            |   Types.Control.Accept
                    UserInterface.drawCharacterKnowledge(character, game_state)
                    cb(@selectedPosition)
            |   Types.Control.Escape
                    UserInterface.drawCharacterKnowledge(character, game_state)
                    cb(void)
            |   otherwise
                @selectCellLoop(character, game_state, cb, on_each)
