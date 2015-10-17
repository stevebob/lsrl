define [
    'blessed'
    'assets/assets'
    'drawing/drawer'
    'front_ends/console/colours'
    'front_ends/console/text'
    'front_ends/console/blessed/drawing/tile'
    'drawing/tile'
    'interface/user_interface'
    'util'
    'types'
], (Blessed, Assets, Drawer, Colours, Text, BlessedTile, Tile, UserInterface, Util, Types) ->

    UNSEEN_COLOUR = Colours.VeryDarkGrey
    SELECTED_COLOUR = Colours.DarkYellow

    class BlessedDrawer extends Drawer
        (@program, @tileTable, @specialColours, @left, @top, @width, @height) ->

            super(@width, @height)

            @tileScheme = new Assets.TileSchemes.Default(BlessedTile.TileSet, BlessedTile.TileType, @width, @height)

            @setDefaultBackground()
            @program.clear()

        setDefaultBackground: ->
            @setBackground(Colours.Black)

        setBackground: (colourId) ->
            @program.write(Text.setBackgroundColour(colourId))

        setForeground: (colourId) ->
            @program.write(Text.setForegroundColour(colourId))

        setBold: ->
            @program.write(Text.setBoldWeight())

        clearBold: ->
            @program.write(Text.setNormalWeight())

        write: (str) ->
            @program.write(str)

        setCursorCart: (v) ->
            @program.setx(v.x)
            @program.sety(v.y)

        drawCharacter: (character, colour, bold) ->
            @setForeground(colour)
            if bold
                @setBold()
            @write(character)
            if bold
                @clearBold()

        drawTile: (tile) ->
            @drawCharacter(tile.character, tile.colour, tile.bold)

        drawUnseenTile: (tile) ->
            @drawCharacter(tile.character, UNSEEN_COLOUR, tile.bold)

        drawUnknownTile: ->
            @drawTile(@tileScheme.tiles.Unknown)

        drawKnowledgeCell: (cell, turn_count) ->
            if cell? and cell.known
                tile = @tileScheme.getTileFromCell(cell)
                if cell.timestamp == turn_count
                    @drawTile(tile)
                else
                    @drawUnseenTile(tile)
            else
                @drawUnknownTile()

        _drawCharacterKnowledge: (character) ->

            turncount = character.getTurnCount()
            grid = character.getKnowledge().grid

            @adjustWindow(character, grid)

            @program.move(0, 0)

            for i from 0 til @window.height
                for j from 0 til @window.width
                    @drawKnowledgeCell(@window.get(grid, j, i), turncount)
                @program.write("\n\r")

        drawCharacterKnowledge: (character) ->
            @_drawCharacterKnowledge(character)
            @program.flushBuffer()

        drawCellSelectOverlay: (character, game_state, select_coord) ->
            @_drawCharacterKnowledge(character)
            cell = character.getKnowledge().grid.getCart(select_coord)
            @setCursorCart(cell)

            @setBackground(SELECTED_COLOUR)
            if cell.known
                tile = @tileScheme.getTileFromCell(cell)
                @drawTile(tile)
            else
                @drawUnknownTile()
            @setDefaultBackground()

            @program.flushBuffer()
