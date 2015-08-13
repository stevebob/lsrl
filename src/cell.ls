define [
    \tile
    \util
    \vec2
    \direction
    \constants
    'prelude-ls'
], (Tile,Util, Vec2, Direction, Constants, Prelude) ->

    map = Prelude.map


    class Cell
        (@x, @y) ->
            @position = Vec2.Vec2 @x, @y
            @ground = void
            @fixture = void
            @items = []
            @characters = []
            @centre = Vec2.Vec2 (@x+0.5), (@y+0.5)
            @corners = []
            @corners[Direction.OrdinalIndices.NorthWest] = Vec2.Vec2 @x, @y
            @corners[Direction.OrdinalIndices.NorthEast] = Vec2.Vec2 (@x+1), @y
            @corners[Direction.OrdinalIndices.SouthWest] = Vec2.Vec2 @x, (@y+1)
            @corners[Direction.OrdinalIndices.SouthEast] = Vec2.Vec2 (@x+1), (@y+1)

            @moveOutCost = 40

        getMoveOutCost: (direction) ->
            if Direction.isCardinal direction.index
                return @moveOutCost
            else
                return @moveOutCost * Constants.SQRT2

        setGround: (G) ->
            @ground = new G this
        setFixture: (F) ->
            @fixture = new F this

        forEachEffectInGroup: (group, f) ->
            for element in group
                element.forEachEffect f

        forEachEffect: (f) ->
            @ground.forEachEffect f
            @fixture.forEachEffect f
            @forEachEffectInGroup @items
            @forEachEffectInGroup @characters

        _forEachEffect: (f) ->
            for e in effects
                f e

    {
        Cell
    }
