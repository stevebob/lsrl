define [
    'system/level'
    'assets/assets'
    'asset_system'
    'util'
    'types'
    'config'
], (Level, Assets, AssetSystem, Util, Types, Config) ->

    class Start extends Level

        (@gameState, @width = Config.DEFAULT_WIDTH, @height = Config.DEFAULT_HEIGHT) ->
            super(@gameState)
            @generator = new Assets.Generator.Surface()

            @children = [
                @createChild(new Assets.Level.BasicDungeon(@gameState)),
                @createChild(new Assets.Level.BasicDungeon(@gameState))
            ]

            for c in @children
                c.createConnections(
                    1,
                    Assets.Feature.StoneDownwardStairs,
                    Assets.Feature.StoneUpwardStairs
                )
                c.level.addConnections(c.connections)

            @fromConnections = @getAllConnections(@children)

        populate: ->
            @addDefaultPlayerCharacter()

            @grid.forEach (c) ~>
                if c.feature.type == Types.Feature.Null and Math.random() < 0.01
                    @addCharacter(new Assets.Character.Spider(c.position, @grid, this, Assets.Controller.SpiderController))
                    c.feature = new Assets.Feature.Web(c)

    AssetSystem.exposeAsset('Level', Start)

