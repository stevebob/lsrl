define [
    'debug'
], (Debug) ->

    class ForwardIterator
        (@_list) ->
            @_current = @_list._head

        hasNext: ->
            return @_current?

        next: !->
            @_current = @_current._next

        get: ->
            return @_current._data

        getNode: ->
            return @_current

        removeCurrent: ->
            @_list.removeNode(@_current)

    class Node
        (@_data, @_list) ->
            @_next = void
            @_prev = void

        get: ->
            return @_data

    class DoublyLinkedList
        ->
            @_head = void
            @_tail = void
            @_length = 0

        first: ->
            return @_head
        last: ->
            return @_tail
        empty: ->
            return @_length == 0
        length: ->
            return @_length

        createNode: (x) ->
            return new Node(x, this)

        insertAtHead: (x) ->
            node = @createNode(x)
            node._next = @_head
            if @_head?
                @_head._prev = node
            else
                @_tail = node
            @_head = node

            ++@_length

        insertAtTail: (x) ->
            node = @createNode(x)
            node._prev = @_tail
            if @_tail?
                @_tail._next = node
            else
                @_head = node
            @_tail = node
            ++@_length

        removeNode: (node) ->
            Debug.assert(node._list == this, "Attempted to remove foreign node")

            --@_length

            if node._next?
                node._next._prev = node._prev
            else
                Debug.assert(@_tail == node, "Non-tail node with no _next field")
                @_tail = node._prev

            if node._prev?
                node._prev._next = node._next
            else
                Debug.assert(@_head == node, "Non-head node with no _prev field")
                @_head = node._next

            return node._data

        removeTail: ->
            return @removeNode(@_tail)

        removeHead: ->
            return @removeNode(@_head)

        push: (x) -> @insertAtHead(x)
        pop: (x) -> return @removeHead()
        enqueue: (x) -> @insertAtHead(x)
        dequeue: (x) -> return @removeTail()

        forEach: (f) ->
            tmp = @_head
            while tmp?
                f(tmp._data)
                tmp = tmp._next

        getForwardIterator: ->
            return new ForwardIterator(this)

    DoublyLinkedList.fromArray = (array) !->
        ret = new DoublyLinkedList()
        for x in array
            ret.insertAtTail(x)
        return ret

    DoublyLinkedList.fromSingleElement = (x) !->
        ret = new DoublyLinkedList()
        ret.insertAtTail(x)
        return ret

    return DoublyLinkedList
