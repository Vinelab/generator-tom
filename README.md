# Tom
### Yeoman Generator for AngularJS Apps

> Why Tom ? Because Tom Waits was playing all along the implementation and was a true inspiration :saxophone:

## Features

### Source Linting
- CoffeeScript source code linting

### Configuration
- Environment-based configuration provided through a ```Config``` class
- Modify configuration attribtues at runtime

### Built-in Servers
- Static server for development
- WebSocket server using [socket.io](http://socket.io)
- Tests server using [Google Chrome's webdriver](https://code.google.com/p/selenium/wiki/ChromeDriver) ([Selenium](http://docs.seleniumhq.org))

### Build Versioning
- Keep builds history
- Navigate and checkout build versions
- Latest build is copied to its own directory *current*

### Assets
- Compiled Javascript with [Browserify](http://browserify.org)
- Minified Javascript with [UglifyJS](https://github.com/mishoo/UglifyJS)
- [LESS](http://www.lesscss.org) CSS pre-processor
- Minified CSS with [clean-css](https://github.com/GoalSmashers/clean-css)

### Local Storage
- Ships with a local storage service that wraps the browser's local storage feature.
- Supports storing mixed data types (arrays, objects, etc.) preserving data type

### WebSockets
- Ships with a socket service that makes it easy to communicate using WebSockets
- It wraps the [socket.io](http://socket.io) client library
- Supports namespaces (a.k.a channels)

### Testing
> Tests will always use the latest build existing in your *current* directory

- Unit tests unsing [Karma](http://karma-runner.github.io)
- [E2E tests]() using [Protractor](https://github.com/angular/protractor)
- All the code provided ships with tests, we :heart: tested code

## Installation
- ```git clone``` this repo
- move into the cloned directory and ```npm link```
- create your project's directory elsewhere ```mkdir ~/dev/my-app && cd $_```
- ```yo tom```
- in another terminal session run ```grunt serve```
- ```grunt``` and you're done

## Commands

### ```grunt```
lint, build, minify, and test. Ideal for compiling for production ahead of deployment.

### ```grunt serve```
run internal servers for development and testing.

- development server to serve static content (index.html) ```http://localhost:9090```
- socket server using [socket.io](http://socket.io) ```http://localhost:9091```
- testing server to be used when running E2E tests ```http://localhost:4444/wd/hub```

### ```grunt build-dev```
lints & builds the project without minifying, sets the latest build as current. Ideal for development.

### ```grunt test```
run all tests.

### ```grunt e2e-test```
run E2E tests only.

### ```grunt unit-test```
run Unit tests only.

### ```grunt list```
list all the builds and show the current one.

### ```grunt checkout:<build|step>```
checkout a build (make it the current one).

- by target ```grunt checkout:2601201422635```
- by step ```grunt checkout:next```
    - supported steps: first, last, next, prev

### Running this project's tests
```mocha --recursive```

## Generators

#### options
> instructions between * are optional

###```--bare```
skip the sub-directory level.

- ```yo tom:controller main --bare``` will result in ```src/Main/MainController.coffee```
instead of ```src/Main/controllers/MainController.coffee```

###```--nofix```
skip prefix or postfix when naming.

- ```yo tom:controller main --nofix``` will result in ```src/Main/controllers/Main.coffee```
instead of ```src/Main/controllers/MainController.coffee```

### controller

```yo tom:controller <feature> *<controller>*```

Example

```yo tom:controller love brain```

app/src/Love/controllers/BrainController

```coffeescript
'use strict'

class BrainController

    ###*
     * Create a new BrainController instance
     *
     * @param  {Config/Config} Config
     * @param  {$scope} $scope
     * @param  {$location} $location
     * @return {BrainController}
    ###
    constructor: (@Config, @$scope, @$location)->

# inject controller dependencies
BrainController.$inject = ['Config', '$scope', '$location']

module.exports = (app)->
    # bring in dependencies
    require('src/Config/Config')(app)

    # register
    app.controller 'BrainController', BrainController
```

### provider

```yo tom:provider <feature> *<provider>*```

Example

```yo tom:provider Stream --nofix```

app/src/Stream/providers/Stream.coffee

```coffeescript
'use strict'

class Stream

    ###*
     * This method is used by Angular to inject dependencies
     * into this provider which in turn will be used
     * to be injected into the constructor.
     *
     * @param  {src/Config/Config} Config
     * @return {Stream}
    ###
    @$get: (Config)-> new this(Config)

    ###*
     * Create a new Stream instance.
     *
     * @param  {src/Config/Config} Config
     * @return {Stream}
    ###
    constructor: (@Config)->

Stream.$inject = ['Config']

module.exports = (app)->
    # bring in dependencies
    require('src/Config/Config')(app)

    # register
    app.provider 'Stream', -> Stream
```

### service

```yo tom:service <feature> *<service>*```

Example

```yo tom:service Api --bare```

app/src/Api/ApiService.coffee

```coffeescript
'use strict'

class ApiService

    ###*
     * Create a new ApiService instnace.
     *
     * @param  {$window} $window
     * @return {ApiService}
    ###
    constructor: (@$window)->

ApiService.$inject = ['$window']

module.exports = (app)-> app.service 'ApiService', ApiService
```

### factory

```yo tom:factory <feature> *<factory>*```

Example

```yo tom:factory chocolate --bare```

app/src/Chocolate/ChocolateFactory.coffee

```coffeescript
'use strict'

class ChocolateFactory

    ###*
     * Create a new ChocolateFactory.
     *
     * @return {ChocolateFactory}
    ###
    constructor: ->

module.exports = (app)-> app.factory 'ChocolateFactory', ChocolateFactory
```

### directive
> ```nofix``` option is ignored

#### options

### ```--restrict```
set the ```restrict``` option. **Default** ```'EA'```

``` yo tom:directive --restrict=E```

### ```--controller```
create a controller along with this directive

``` yo tom:directive --controller```

or you may specify the controller prefix

```yo tom:directive --controller=edit``` will resutl in ```EditController```

### ```--templateUrl```
set a URL for your template, will also create an empty template defaulting to the name of the directive in ```app/views/<directive>.html```

### ```--transclude```
set the transclude option to ```true```. **Default** not included

Examples

```yo tom:directive customers myCustomer --transclude --restrict=E --bare```

app/src/Customers/myCustomer.coffee

```coffeescript
'use strict'

module.exports = (app)-> app.directive 'myCustomer', ->

    {
        restrict: 'E'
        transclude: yes
        template: ''
        scope: { }
        link: (scope, element, attrs)->
    }
```

```yo tom:directive customers myCustomer --bare --controller --templateUrl=app/views/my-customer.html```


app/src/Customers/myCustomer.coffee
```coffeescript
'use strict'

class MyCustomerController

    ###*
     * Create a new MyCustomerController instance
     *
     * @param  {Config/Config} Config
     * @param  {$scope} $scope
     * @return {MyCustomerController}
    ###
    constructor: (@Config, @$scope)->

# inject controller dependencies
MyCustomerController.$inject = ['Config', '$scope']

module.exports = (app)-> app.directive 'myCustomer', ->

    {
        restrict: 'EA'
        templateUrl: 'app/views/mycustomer.html'
        controller: MyCustomerController
    }
```

#### using controllers
when implementing a controller for a directive, you might like to have methods accessible to the directive directly, these methods should be registered to ```$scope```:

```coffeescript
class MyCustomerController

    constructor: (@Config, @$scope)->
        @$scope.customers = [
            {
                name: 'Naomi'
                address: '1600 Amphetheatre'
                active: no
            }

        @$scope.activate = => @$scope.customer.active = yes
        @$scope.disactivate = => @$scope.customer.active = no

        # you can also proxy to the class preserving context
        @$scope.do = @justDoIt

    justDoIt: -> # √

# inject controller dependencies
MyCustomerController.$inject = ['Config', '$scope']

module.exports = (app)-> app.directive 'myCustomer', ->

    {
        restrict: 'EA'
        controller: MyCustomerController
        templateUrl: '/app/views/customer.html'
    }
```

and the directive can access it directly:
```html
<div>{{customer.name}} - {{customer.address}}</div>
<div ng-show="customer.active">Active!</div>
<a href ng-hide="customer.active" ng-click="activate()">Activate!</a>
<a href ng-show="customer.active" ng-click="disactivate()">Disactivate</a>
<a href ng-click="do()">Just Do It</a>
```

License
--------
[MIT license](http://opensource.org/licenses/MIT) Copyright © Vinelab