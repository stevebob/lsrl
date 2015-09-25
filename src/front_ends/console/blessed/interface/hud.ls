define [
    'front_ends/console/box'
    'front_ends/console/colours'
    'front_ends/console/text'
    'front_ends/console/blessed/util'
], (Box, Colours, Text, BlessedUtil) ->

    class Hud implements BlessedUtil.Boxable
        (@program, @left, @top, @width, @height) ->
            @border = Box.BorderSingleLineUnicode
            @drawBox()

        updateHud: (character) ->
            @clear()
            @program.move(@left + 1, @top + 1)
            @program.write(Text.setForegroundColour(Colours.White))
            @program.write(Text.setNormalWeight())
            @program.write("#{character.getName()}  Curse: #{character.getCurrentHitPoints()}")
            @program.flushBuffer()