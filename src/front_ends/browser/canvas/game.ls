define [
    'common/game'
    'front_ends/browser/canvas/drawing/tile'
    'front_ends/browser/canvas/interface/input'
    'front_ends/browser/canvas/interface/console'
    'front_ends/browser/canvas/interface/hud'
    'tile_schemes/default'
    'assets/assets'
    'util'
    'config'
], (GameCommon, Tile, BrowserInputSource, Console, Hud, DefaultTileScheme, Assets, Util, Config) ->

    class Game extends GameCommon
        ->

            @seedRandom()

            Assets.Colour = Assets.BrowserColour
            Assets.TileSet.UnicodeTileSet.install()
            Assets.TileSet.Default = Assets.TileSet.UnicodeTileSet

            input = new BrowserInputSource()
            drawer = new Assets.Drawer.CanvasUnicodeDrawer($('#canvas')[0], new DefaultTileScheme(Tile.TileSet),
                Config.DEFAULT_WIDTH, Config.DEFAULT_HEIGHT, input)
            game_console = new Console($('#log'))
            hud = new Hud($('#hud'))

            super(drawer, input, game_console, hud)


    main = ->

        pairs = window.location.search.split("?").filter (.length)
        for p in pairs
            [key, value] = p.split("=")
            Config[key] = value

        new Game().start()

    {
        Game
        main
    }
