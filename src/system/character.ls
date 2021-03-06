define [
    'interface/user_interface'
    'system/effectable'
    'assets/observer/recursive_shadowcast'
    'assets/observer/omniscient'
    'types'
    'config'
], (UserInterface, Effectable, RecursiveShadowcast, Omniscient, Types, Config) ->

    if Config.OMNISCIENT_CHARACTERS
        Observer = new Omniscient()
    else
        Observer = new RecursiveShadowcast()

    class Character implements Effectable
        (@position, @grid, @level, @Controller) ->
            @initEffectable()
            @controller = new @Controller(this, @position, @grid)
            @hitPoints = 10
            @alive = true

        setLevel: (@level) ->
            @grid = @level.grid

        initGameState: (game_state) ->
            @continuousEffects = game_state.continuousEffects.createChild()

        getPosition: ->
            return @position

        getTurnCount: ->
            return @controller.getTurnCount()

        observe: (game_state) ->
            @controller.knowledge.beforeObserve()
            Observer.observe(@controller, game_state)
            @controller.turnCount = game_state.getTurnCount()
            @controller.knowledge.afterObserve()

        getController: ->
            return @controller

        getCell: ->
            return @grid.getCart(@getPosition())

        getKnowledgeCell: ->
            @controller.getKnowledgeCell()

        setAutoMove: (auto_move) ->
            @controller.setAutoMove(auto_move)

        getAction: (game_state, callback) ->
            @controller.getAction(game_state, callback)

        getInventory: ->
            @controller.inventory

        getKnowledge: ->
            @controller.knowledge

        getCurrentAttackDamage: ->
            return new Damage.PhysicalDamage(3)

        getCurrentHitPoints: ->
            return @hitPoints

        takeDamage: (damage) ->
            @hitPoints = Math.max(0, @hitPoints - damage)

        setObserverNode: (node) ->
            @observerNode = node

        die: (game_state) ->
            if @alive
                @alive = false
                @controller.deactivate()
                if @observerNode?
                    game_state.removeObserverNode(@observerNode)
                @getCell().character = void

        notifyEffectable: (action, relationship, game_state) ->
            @weapon.notify(action, relationship, game_state)

        unequipItem: (equipment_slot) ->
            item = equipment_slot.item
            equipment_slot.item = equipment_slot.default
            item.unequip()

        equipItem: (item, equipment_slot) ->
            equipment_slot.item = item
            item.equip(equipment_slot)

        getWeapon: ->
            return @equipmentSlots.weapon.item
