# Coffee Factory

Javascript class Factory generator implemented in Coffeescript.

## Install

    npm install --save coffee-factory

## Usage

### CommonJS Module

#### `new Factory(klass, maxReuse)` → Factory Instance

 * `klass` The class to instantiate when `.get()` called
 * `maxReuse` The maximum number of existing instance to keep at any one time. FIFO.

#### `Factory#get()` → `klass` instance
#### `Factory#put(obj)`

 * `obj` An instance to give the Factory for re-use

## Examples

```coffeescript
Factory = require 'coffee-factory'

class User
  name: ""

  initialize: ->
    @name = ""

  setName: (@name) ->

  toString: ->
    return @name

# Create the factory
UserFactory = new Factory User, 10

# Get an instance. No instances are stored in the factory, so a new one is created
user = UserFactory.get()
user.setName "Foo Smith"

console.log user # Output: "Foo Smith"

# We no longer want this instance, so let the factory reuse it
UserFactory.put user
user = null

# Get another instance. There is one stored, so that will be used.
# Before returning, `.initialize` (if it exists) will be called on the instance
user2 = UserFactory.get()
console.log user # Output: ""

user.setName "Bar Zip"
console.log user # Output: "Bar Zip"
```
