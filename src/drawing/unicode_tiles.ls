define [
    'drawing/character_tiles'
    'util'
    'types'
    'debug'
], (CharacterTiles, Util, Types, Debug) ->

    Tiles =
        Error:                      ['?', 'LightRed',   false]
        Unknown:                    [' ', 'Black',      false]
        Stone:                      ['.', 'LightGrey',  false]
        Dirt:                       ['.', 'DarkBrown',  false]
        Tree:                       ['&', 'DarkGreen',  false]
        Wall:                       ['#', 'DarkGrey',   false]
        SpiderWeb:                  ['*', 'LightGrey',  false]
        Moss:                       ['.', 'LightGreen', false]
        ItemStone:                  ['[', 'LightGrey',  false]
        ItemPlant:                  ['%', 'LightGreen', false]
        Door:                       ['+', 'LightGrey',  false]
        OpenDoor:                   ['-', 'LightGrey',  false]
        Human:                      ['h', 'White',      true]
        Shrubbery:                  ['p', 'DarkGreen',  true]
        PoisonShrubbery:            ['p', 'Purple',     true]
        CarnivorousShrubbery:       ['p', 'LightGreen', true]
        PlayerCharacter:            ['@', 'White',      true]
        DirtWall:                   ['#', 'DarkBrown',  false]
        BrickWall:                  ['#', 'LightRed',   false]
        Water:                      ['~', 'Blue',       false]
        Water2:                     ['≈', 'Blue',       false]
        Grass:                      ['.', 'DarkGreen',  false]
        Bridge:                     ['=', 'LightBrown',  false]

    Debug.Chars.map (ch) ->
        Tiles[ch] = [ch, Debug.getColour(ch, 'White'), false]

    {
        createTileSet: (T) -> CharacterTiles.createTileSet(Tiles, T)
        TileType: CharacterTiles.TileType
    }
