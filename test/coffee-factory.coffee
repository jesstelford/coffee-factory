Factory = require '../lib/coffee-factory'

describe 'Factory Instantiation', ->

  it 'rejects klass if not instantiable with `new`', ->

    try
      fac = new Factory {}
      ok no # Should throw before here
    catch e
      ok e instanceof TypeError
      ok e.toString().match /is not instantiable with `new`$/

  it 'creates a new Factory instance', ->
    Foo = ->
    fac = new Factory Foo
    ok fac instanceof Factory

describe 'Instances', ->

  describe 'Creation', ->

    beforeEach ->
      class @klass

    it '`get` returns an instance of klass', ->

      fac = new Factory @klass
      obj = fac.get()
      ok obj instanceof @klass

    it '`put` will only accept objects of type `klass`', ->

      Foo = ->
      fac = new Factory @klass
      obj = new Foo

      try
        fac.put obj
        ok no # Should throw before here
      catch e
        ok e instanceof TypeError
        ok e.toString().match /Factory can only store an instance of type/

    it 'will not reuse if no max specified', ->

      fac = new Factory @klass
      obj = new @klass
      fac.put obj
      obj2 = fac.get()
      ok obj2 isnt obj

  describe 'Reusing', ->

    beforeEach ->
      class @klass
      @fac = new Factory @klass, 2

    it 'is a FIFO system', ->

      obj1 = new @klass
      obj2 = new @klass
      @fac.put obj1
      @fac.put obj2

      eq @fac.get(), obj1
      eq @fac.get(), obj2

      newObj = @fac.get()
      ok newObj isnt obj1 and newObj isnt obj2

    it 'is a LRU system', ->

      obj1 = new @klass
      obj2 = new @klass
      obj3 = new @klass
      @fac.put obj1
      @fac.put obj2
      @fac.put obj3

      eq @fac.get(), obj2
      eq @fac.get(), obj3

      newObj = @fac.get()
      ok newObj isnt obj1 and newObj isnt obj2 and newObj isnt obj3

  describe 'Initialization of klass', ->

    beforeEach ->
      class @klass
        called: 0
        foo: "adsfasdf"
        initialize: (@foo, @bar) ->
          @called++

      @fac = new Factory @klass, 1

    it 'Calls initialize on new instances', ->

      obj1 = @fac.get()
      eq obj1.called, 1

    it 'Calls initialize on reused instances', ->

      obj1 = new @klass()
      @fac.put obj1

      obj2 = @fac.get()
      eq obj2.called, 1

    it "passes through arguments to klass's initialize", ->

      obj = @fac.get "foo", "bar"
      eq obj.foo, "foo"
      eq obj.bar, "bar"

  describe 'constructor args', ->

    beforeEach ->
      class @klass
        constructor: (@foo, @bar) ->
      @fac = new Factory @klass, 1, "foo", "bar"

    it 'accepts default construction params', ->

      obj = @fac.get()
      eq obj.foo, "foo"
      eq obj.bar, "bar"

    it 'can change default construction params', ->

      @fac.setConstructorArgs "zip", "yah"
      obj = @fac.get()
      eq obj.foo, "zip"
      eq obj.bar, "yah"
