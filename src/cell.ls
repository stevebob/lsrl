define [
    \tile
    \effect
    \util
    \vec2
    'prelude-ls'
], (Tile, Effect, Util, Vec2, Prelude) ->

    map = Prelude.map

    class Cell
        (@x, @y) ->
            @position = Vec2.Vec2 @x, @y
            @ground = void
            @fixture = void
            @items = []
            @characters = []

        setGround: (G) -> 
            @ground = new G this
        setFixture: (F) -> 
            @fixture = new F this

        forEachEffectInGroup: (group, f) ->
            group.forEach (element) ->
                element.forEachEffect f

        forEachEffect: (f) ->
            @ground.forEachEffect f
            @fixture.forEachEffect f
            @forEachEffectInGroup @items
            @forEachEffectInGroup @characters

        _forEachEffect: (f) ->
            @effects.forEach f

    floorPrototype = (tile) -> {
        type: tile
        effects: []
    }

    wallPrototype = -> {
        type: Tile.Tiles.WALL
        effects: [
            Effect.CellIsSolid
        ]
    }

    {
        Cell
        floorPrototype
        wallPrototype
    }
