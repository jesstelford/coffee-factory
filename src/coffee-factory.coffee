module.exports = class Factory

  usable: []
  args: []

  constructor: (@klass, @maxReuse = 0, args...) ->
    if typeof @klass isnt 'function'
      throw new TypeError "#{@klass} is not instantiable with `new`"

    if @maxReuse < 0 then @maxReuse = 0
    @setConstructorArgs.apply this, args

  setConstructorArgs: (args...) ->
    @args = [null].concat args

  get: ->
    if @usable.length > 0
      obj = @usable.shift()
    else
      obj = new (@klass.bind.apply(@klass, @args))()

    if typeof @klass::initialize is 'function'
      @klass::initialize.apply obj, arguments

    return obj

  put: (obj) ->
    if not (obj instanceof @klass)
      throw new TypeError "Factory can only store an instance of type #{@klass}"

    if @maxReuse > 0
      if @usable.length >= @maxReuse 
        @usable.shift()
      @usable.push obj

    return
