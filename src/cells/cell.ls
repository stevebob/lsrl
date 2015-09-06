define [
    'structures/vec2'
    'structures/direction'
    'items/inventory'
    'constants'
    'types'
], (Vec2, Direction, Inventory, Constants, Types) ->

    class Cell
        (@x, @y) ->
            @position = Vec2.Vec2 @x, @y
            @character = void
            @ground = void
            @fixture = void
            @items = new Inventory.Inventory()
            @characters = []
            @centre = Vec2.Vec2 (@x+0.5), (@y+0.5)
            @corners = []
            @corners[Types.OrdinalDirection.NorthWest] = Vec2.Vec2 @x, @y
            @corners[Types.OrdinalDirection.NorthEast] = Vec2.Vec2 (@x+1), @y
            @corners[Types.OrdinalDirection.SouthWest] = Vec2.Vec2 @x, (@y+1)
            @corners[Types.OrdinalDirection.SouthEast] = Vec2.Vec2 (@x+1), (@y+1)

            @moveOutCost = 40

        getMoveOutCost: (direction) ->
            if Direction.isCardinal direction
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
            @forEachEffectInGroup @characters

        _forEachEffect: (f) ->
            for e in effects
                f e

        addItem: (item) ->
            @items.insertItem item

    {
        Cell
    }
