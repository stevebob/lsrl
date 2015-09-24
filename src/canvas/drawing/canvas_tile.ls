define [
    'types'
    'util'
], (Types, Util) ->

    const AsciiTileStyles = Util.table Types.Tile, {
        Error:  ['?', '#ff0000']
        Unknown:[' ', '#0000ff']
        Stone:  ['.', '#888888']
        Moss:   ['.', '#00ff00']
        Dirt:   ['.', '#996600']
        Tree:   ['&', '#669900']
        Wall:   ['#', '#666666']
        SpiderWeb:     ['*', '#888888']
        ItemStone: ['[', '#666666']
        ItemPlant: ['%', '#30b020']
        Door: ['+', '#888888']
        OpenDoor: ['-', '#888888']
        Human: ['h', '#ffffff', 'bold']
        Shrubbery: ['p', '#006600', 'bold']
        CarnivorousShrubbery: ['p', '#00FF00', 'bold']
        PoisonShrubbery: ['p', '#993399', 'bold']
        PlayerCharacter: ['@', '#ffffff', 'bold']
        DirtWall: ['#', '#996600']
        BrickWall: ['#', '#ff5500']
    }

    
    const UnseenColour = '#333333'
    const SelectColour = '#888800'

    {
        AsciiTileStyles
        UnseenColour
        SelectColour
    }
