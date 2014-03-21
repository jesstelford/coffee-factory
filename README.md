# Coffee Factory

Javascript class Factory generator implemented in Coffeescript.

## Install

    npm install --save coffee-factory

## Usage

### CommonJS Module

#### `new Factory(klass, maxReuse, ctorArgs...)` → Factory Instance

 * `klass` The class to instantiate when `Factory#get()` called
 * `maxReuse` The maximum number of existing instance to keep at any one time. FIFO.
 * `ctorArgs` Arguments passed to constructor when new instantiations created

#### `Factory#get(initArgs...)` → `klass` instance

 * `initArgs` Arguments passed to `.initialize()` of instance when `Factory#get()` called

#### `Factory#put(obj)`

 * `obj` An instance to give the Factory for re-use

## Examples

### Basic Usage

```coffeescript
Factory = require 'coffee-factory'

class User
  name: "default"
  initialize: ->
    @name = ""

UserFactory = new Factory User, 10 # Create the factory

# Get an instance.
# No instances are stored in the factory, so a new one is created
user = UserFactory.get()
console.log user.name # Output: "" - because `.initialize()` is called

user.name = "Foo"

# We no longer want this instance, so let the factory reuse it
UserFactory.put user
user = null
# Normally, garbage collection would delete the object form memory

# Get another instance. There is one stored, so that will be used.
# Before returning, `.initialize` (if it exists) will be called on the instance
user2 = UserFactory.get()
console.log user.name # Output: ""
```

### Passing params to `initialize`

```coffeescript
Factory = require 'coffee-factory'

class User
  name: "default"
  initialize: (@name = "") ->

UserFactory = new Factory User, 10 # Create the factory

user = UserFactory.get "Foo"
console.log user.name # Output: "Foo" - the param was passed to `.initialize()`
```

### Passing params to the constructor

```coffeescript
Factory = require 'coffee-factory'

class User
  name: "default"
  constructor: (@name = "") ->

# The "Foo" parameter will be passed to the constructor of User when `.get()` is called
UserFactory = new Factory User, 10, "Foo"

user = UserFactory.get()
console.log user.name # Output: "Foo"

user2 = UserFactory.get()
console.log user2.name # Output: "Foo"
```

### Usage as a Default Constructor system

```coffeescript
Factory = require 'coffee-factory'

class User
  isStaff: false
  constructor: (@isStaff) ->

# The "Foo" parameter will be passed to the constructor of User when `.get()` is called
StaffUser = new Factory User, 10, true

ceo = StaffUser.get()
console.log ceo.isStaff # Output: true
```

## Donations

Like what I've created? *So do I!* I develop this project in my spare time, free for the community.

If you'd like to say thanks, buy me a beer by **tipping with Dogecoin**: *DJLZccHAcz19ikSV1D5jY3WdFPU7Nqjmfk*
