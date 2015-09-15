define [
    'common/game_common'
    'curses/drawing/curses_drawer'
    'curses/interface/curses_input_source'
    'curses/interface/console'
    'curses/interface/hud'
    'interface/keymap'
    'interface/user_interface'
    'util'
    'config'
], (GameCommon, CursesDrawer, CursesInputSource, Console, Hud, Keymap, UserInterface, Util, Config) ->

    class Game extends GameCommon
        ->
            drawer = new CursesDrawer.CursesDrawer()

            convert = Keymap.convertFromDvorak
            input = new CursesInputSource.CursesInputSource(drawer.gameWindow, convert)
            game_console = new Console.Console(drawer.logWindow, drawer.gameWindow, drawer.ncurses)
            hud = new Hud.Hud(drawer.hudWindow)

            process.on('SIGINT', drawer.cleanup)
            process.on('exit', drawer.cleanup)

            super(drawer, input, game_console, hud)

    main = -> new Game().start()

    {
        Game
        main
    }
