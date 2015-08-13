define [
    \action
    \control
    \knowledge
    \recursive_shadowcast
    \omniscient
    \direction
    \ground
    \fixture
    \flood
    \search
    \types
    \util
    'prelude-ls'
    \config
], (Action, Control, Knowledge, Shadowcast, Omniscient, Direction, Ground, Fixture, Flood, Search, Types, Util, Prelude, Config) ->

    map = Prelude.map

    class AutoMove
        (@direction) ->

    class Surroundings
        (@centre, @direction) ->
            @cells = Direction.Fronts[@direction.index] |> map (i) ~> @centre.neighbours[i]

        equals: (other) ->
            for i from 0 til @cells.length
                if @cells[i].fixture.type != other.cells[i].fixture.type
                    return false
            return true

    class PlayerCharacter
        (@position, @inputSource, @grid) ->
            @effects = []
            @knowledge = new Knowledge.Knowledge grid
            @viewDistance = 20

            if Config.OMNISCIENT_PLAYER
                @observe_fn = Omniscient.observe
            else
                @observe_fn = Shadowcast.observe

            @autoMode = null

        forEachEffect: (f) ->
            for e in @effects
                f e

        getAction: (game_state, cb) ->
            if @autoMode? and @autoMode.constructor == AutoMove
                new_surroundings = new Surroundings @getCell!, @autoMode.direction
                if @surroundings.equals new_surroundings and @surroundings.centre.position.add(Direction.DirectionVectorsByIndex[@surroundings.direction.index]).equals(new_surroundings.centre.position)
                    @surroundings = new_surroundings
                    cb new Action.Move this, @autoMode.direction, game_state
                    return
                else
                    @autoMode = null

            if @autoMode == null
                @inputSource.getControl (control) ~>
                    if not control?
                        @getAction game_state, cb
                        return

                    a = void
                    if control.type == Control.ControlTypes.Direction
                        a = new Action.Move this, control.direction, game_state
                    else if control.type == Control.ControlTypes.AutoDirection
                        a = new Action.Move this, control.direction, game_state
                        @autoMode = new AutoMove control.direction
                        @surroundings = new Surroundings @getCell!, @autoMode.direction
                    else if control.type == Control.ControlTypes.AutoExplore

                        result = Search.findClosest @getKnowledgeCell!, ((c, d) -> c.game_cell.getMoveOutCost d), \
                            ((c) -> c.known and c.fixture.type == Types.Fixture.Null), \
                            ((c) -> c.hasUnknownNeighbour!)

                        result.cell.game_cell.setGround Ground.Moss
                        a = new Action.Null this, game_state

                    cb a

        getCell: -> @grid.getCart @position
        getKnowledgeCell: -> @knowledge.grid.getCart @position

        getName: -> "The player"

        canSeeThrough: (cell) ->
            cell.fixture.type != Types.Fixture.Wall

        observe: (game_state) ->
            @observe_fn this, game_state

    {
        PlayerCharacter
    }
