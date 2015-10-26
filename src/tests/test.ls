define [
    'prelude-ls'
    'generation/border_generator'
    'generation/vision_test_generator'
    'generation/perlin_test_generator'
    'generation/cell_automata_test_generator'
    'generation/maze_generator'
    'controllers/player_controller'
    'character/character'
    'structures/vec2'
    'common/game_state'
    'cell/cell'
    'assets/features/features'
    'util'
    'structures/linked_list'
    'structures/binary_tree'
    'structures/avl_tree'
    'structures/group_tree'
    'item/item'
    'structures/search'
    'interface/auto_move'
    'interface/user_interface'
    'controllers/null_controller'
    'config'
    'types'
    'controllers/shrubbery_controllers'
    'action/effect'
    'assets/assets'
    'drawing/tile'
    'front_ends/browser/canvas/drawing/tile'
], (prelude, border_generator, vision_test, perlin_test_generator, cell_automata_test_generator, MazeGenerator, \
    PlayerController, character, Vec2, GameState, Cell, Feature, Util, LinkedList, BinaryTree, \
    AvlTree, GroupTree, Item, Search, AutoMove, UserInterface, NullController, Config, Types, ShrubberyControllers, \
    Effect, Assets, Tile, CanvasTile) ->

    const WIDTH = 80
    const HEIGHT = 30

    test = ->

        drawer = UserInterface.Global.gameDrawer
        input_source = UserInterface.Global.gameController

        if Config.GENERATOR == 'cell_automata'
            c = new cell_automata_test_generator.CellAutomataTestGeneratorRooms()
        else if Config.GENERATOR == 'maze'
            c = new MazeGenerator.MazeGenerator()
        else if Config.GENERATOR == 'border'
            c = new border_generator()
        else if Config.GENERATOR == 'catacombs'
            c = new Assets.Generators.Catacombs()
        else if Config.GENERATOR == 'castle'
            c = new Assets.Generators.Castle()
        else if Config.GENERATOR == 'perlin'
            c = new perlin_test_generator()
        else if Config.GENERATOR == 'surface'
            c = new Assets.Generators.Surface()
        else if Config.GENERATOR == 'vision_test'
            c = new vision_test()


        grid = c.generateGrid(Cell, WIDTH, HEIGHT)

        if Config.DRAW_MAP_ONLY
            drawer.drawGrid grid
            return

        sp = c.getStartingPointHint()

        pos = new Vec2(sp.x, sp.y)
        char = new Assets.Characters.Human(pos, grid, PlayerController)
        drawer.tileScheme.setPlayerCharacter(char)
        drawer.setTileStateData(drawer.tileScheme.createTileStateData(WIDTH, HEIGHT))
        grid.get(sp.x, sp.y).character = char
        gs = new GameState(grid, char.controller)

        if Config.GENERATOR == 'cell_automata'
            grid.forEach (c) ->
                if Math.random() < 0.03
                    if c.feature.type == Types.Feature.Null
                        c.feature = new Feature.Web()
                else if Math.random() < 0.03
                    if c.feature.type == Types.Feature.Null
                        item = new Item.Stone()
                        c.addItem item
                else if Math.random() < 0.03
                    if c.feature.type == Types.Feature.Null
                        c.addItem new Item.Plant()
                else if Math.random() < 0.01
                    if c.feature.type == Types.Feature.Null
                        c.character = new Assets.Characters.Shrubbery(c.position, grid, NullController)
                else if Math.random() < 0.005
                    if c.feature.type == Types.Feature.Null and not c.character?
                        c.character = new Assets.Characters.PoisonShrubbery(c.position, grid, ShrubberyControllers.PoisonShrubberyController)
                        gs.scheduleActionSource(c.character.controller, 0)
                else if Math.random() < 0.005
                    if c.feature.type == Types.Feature.Null and not c.character?
                        c.character = new Assets.Characters.CarnivorousShrubbery(c.position, grid, ShrubberyControllers.CarnivorousShrubberyController)
                        gs.scheduleActionSource(c.character.controller, 0)

        gs.registerObserver(char)
        char.addEffect(new Effect.ResurrectOnDeath())

        return gs

    {
        test
    }
