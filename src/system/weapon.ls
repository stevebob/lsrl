define [
    'system/effectable'
    'system/item'
], (Effectable, Item) ->

    class Weapon implements Effectable, Item
        ->
            @initEffectable()

        getAttackDamage: ->
            return 0
