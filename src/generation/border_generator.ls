define [
    'cell/fixture'
    'cell/ground'
    'structures/grid'
], (Fixture, Ground, Grid) ->

    class BorderGenerator
        generateGrid: (T, width, height) ->
            grid = new Grid(T, width, height)
            grid.forEach (c) ->
                c.setGround Ground.Stone
                c.setFixture Fixture.Null
            grid.forEachBorder (c) ->
                c.setFixture Fixture.Wall

            @grid = grid
            return grid

        getStartingPointHint: -> @grid.get(2, 2)
