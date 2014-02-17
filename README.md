# Tom [![Build Status](https://travis-ci.org/Vinelab/generator-tom.png?branch=master)](https://travis-ci.org/Vinelab/generator-tom)
### :a: Yeoman Generator for AngularJS App Scaffold in CoffeeScript

> Why Tom ? Because Tom Waits was playing all along the implementation and was a true inspiration :saxophone:

## Features

### Source Linting
- CoffeeScript source code linting

### Configuration
- Environment-based configuration, set ```NODE_ENV``` environment variable to ```development``` on your machine for a successful build
- Modify configuration attribtues at runtime

#### usage
Configuration is provider through a class called ```Config``` with two function for ```get```ting and ```set```ting configuration attribtues.

#### ```get```
The example below shows a sample configuration for the ```api``` attribue in ```app/config/development.yml```

```yaml
api:
    credentials:
        key: '7968tuyfgjhavsbdfjk'
    host: 'http://api.service.url'
    redirect_url: 'http://my.place.url'
```

to load this configuration when needed

```coffeescript
api = Config.get('api') # Object { credentials: ..., host: ..., redirect_url: ...}
```

you may also dig for a deeper path inside attribtues using ```dot``` notation

```coffeescript
host = Config.get('api.host')
api_key = Conig.get('api.credentials.key')
```

#### ```set```
setting an attribtue is as easy as getting it
```coffeescript
Config.set('api.host', 'http://some.other.url')
```

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
- Delivery of static assets from a CDN

#### CDN
Deliver your build's static files from an external CDN.

In the desired environment's configuration file. i.e. ```app/config/production.yml```

##### specify endpoints
> **WARNING** endpoints will be whitelisted with Angular's [ng.$sceDelegateProvider.whitelist](http://docs.angularjs.org/api/ng.$sceDelegateProvider)

```yaml
cdn:
    url: 'http://cdn.service.url'
```

You may also specify an endpoint per asset type:
> supported: ```html,css,js,img```

```yaml
cdn:
    url: 'http://cdn.service.url'
    html: 'http://cdn.assets.html.service.url'
    css: 'http://cdn.assets.css.service.url'
    js: 'http://cdn.assets.js.service.url'
    img: 'http://cdn.images.service.url'
```
And if one of the types does not exist it will fallback to ```cdn:url```, however if the ```cdn``` configuration is not found the URIs will only be preceded by a ```/``` delivering from the same host (```self```).

### serving assets
- ```CDN.template('uri/here.html')``` for ```HTML```
- ```CDN.css('uri/style.css')``` for ```CSS```
- ```CDN.js('my/script.js')``` for ```Javascript```
- ```CDN.img('pretty/penguin.jpg')``` for images


#### deploy to AWS S3
- deploy your assets directly to Amazon Simple Storage Service (using [grunt-aws](https://www.npmjs.org/package/grunt-aws))
    - configure **aws** in ```aws.json```
    - use ```grunt deploy:aws``` to deploy

##### *tip:* multiple buckets

```javascript
// aws.json
{
    "s3": {
        "buckets": {
            "default": "my-default-duck",
            "html": "my-html-only"
        },

        "key": "",

        "secret": ""
    }
}
```

```coffeescript
# Gruntfile.coffee

...

s3: {

    options:
        bucket: '<%= aws.s3.buckets.default %>'
        accessKeyId: '<%= aws.s3.key %>'
        secretAccessKey: '<%= aws.s3.secret %>'

    current:
        cwd: 'current/'
        src: '**'

    views:
        options:
            bucket: '<%= aws.s3.buckets.html %>'
        cwd: 'app/views/'
        src: '**'
}

...

```

### Local Storage
- Ships with a local storage service that wraps the browser's local storage feature
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
- install [yeoman](http://yeoman.io)
- via [npm](https://npmjs.org/package/generator-tom) ```npm install -g generator-tom```
- create your project's directory ```mkdir ~/dev/my-app && cd $_```
- ```yo tom```
- in another terminal session run ```grunt serve```
- ```grunt``` and you're done

## Directory Structure
```yaml
- app
    - assets            : asset resources (styles and images)
    - config            : app configuration files
    - src               : app features source files
    - views             : app views
- builds                : builds versions (created after the first build)
- current               : the current build's code (created after the first build)
- lib                   : built-in libraries
- tests                 : all your tests go here
    - e2e               : end to end testing files (filnames should follow *Test.coffee)
        - config        : configuration for E2E tests
    - unit              : unit testing files (filenames should follow *Test.coffee)
        - config        : configuration for unit tests
- app.yml               : list your app's components
```

## App Foundation
separate listing of dependencies makes it seamless to replace the implementation of a feature or module as long as their interface (usage) match, almost what the [Liskov principle](http://en.wikipedia.org/wiki/Liskov_substitution_principle) is about. An easy way to load the app's foundational components is to list them in ```app.yml``` as such:

```yaml
classmap:
    - app/routes.coffee:routes
    - app/filters.coffee:filters
    - lib/CDN/CDN.coffee:CDN
    - lib/Config/Config.coffee:Config
    - lib/Socket/Socket.coffee:Socket
    - lib/Storage/StorageService.coffee:Storage
    - app/src/Main/controllers/MainController.coffee:MainController

autoload:
-
    expand: yes
    cwd: lib
    src:
    - Storage/**/*.coffee
    - Socket/**/*.coffee
    dest: lib/
```
### ```classmap```
will be translated as a browserify ```alias```, exposing the file/module as specified after ```:``` which makes it possible to ```require``` the module by alias.

*example:* ```app/routes.coffee:routes``` can be included as ```require('routes')``` in any class

### ```autoload```
will be translated to ```aliasMappings``` in browserify, loads the files according to the patterns in ```src``` and exposes them according to the ```dest```

*example:*

```yaml
-
    expand: yes
    cwd: lib
    src:
    - Storage/**/*.coffee
    - Socket/**/*.coffee
    dest: lib/
```

now we can ```require('lib/Storage/StorageService')``` and anything under those directories.

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

### ```grunt deploy:aws```
deploy static assets to an AWS S3 bucket. Will upload everything inside ```current/``` and ```app/views/```

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
----------
### TODO
- sub generator for tests
- exception handling

License
--------
[MIT license](http://opensource.org/licenses/MIT) Copyright © Vinelab