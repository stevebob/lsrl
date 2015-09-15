define [
    'common/game_common'
    'canvas/drawing/canvas_drawer'
    'canvas/interface/browser_input_source'
    'canvas/interface/console'
    'canvas/interface/hud'
    'interface/keymap'
    'interface/user_interface'
    'util'
    'config'
], (GameCommon, CanvasDrawer, BrowserInputSource, Console, Hud, Keymap, UserInterface, Util, Config) ->

    class Game extends GameCommon
        ->
            if window.location.hash == '#qwerty'
                convert = Keymap.convertFromQwerty
            else
                convert = Keymap.convertFromDvorak

            input = new BrowserInputSource(convert)
            drawer = new CanvasDrawer($('#canvas')[0], 120, 40, input)
            game_console = new Console($('#log'))
            hud = new Hud($('#hud'))

            super(drawer, input, game_console, hud)


    main = -> new Game().start()

    {
        Game
        main
    }
