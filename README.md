# VLB Yeoman Generator - AngularJS

## Features

### Source Linting
- CoffeeScript source code linting

### Configuration
- Environment-based configuration provided through a ```Config``` class
- Modify configuration attribtues at runtime

### Built-in Servers
- Static server for development
- WebSocket server using [socket.io](socket.io)
- Tests server using [Google Chrome's webdriver](https://code.google.com/p/selenium/wiki/ChromeDriver) ([Selenium](http://docs.seleniumhq.org))

### Build Versioning
- Keep builds history
- (todo) Navigate and checkout build versions
- Latest build is copied to its own directory *current*

### Assets
- Compiled Javascript with [Browserify](http://browserify.org)
- Minified Javascript with [UglifyJS](https://github.com/mishoo/UglifyJS)
- [LESS](http://www.lesscss.org) CSS pre-processor
- Minified CSS with [clean-css](https://github.com/GoalSmashers/clean-css)

### Local Storage
- Ships with a local storage service that wraps the browser's local storage feature.
- (todo) add support to store mixed data types (arrays, objects, etc.)

### WebSockets
- Ships with a socket service that makes it easy to communicate using WebSockets
- It wraps the [socket.io](socket.io) client library
- Supports namespaces (a.k.a channels)

### Testing
> Tests will always use the latest build existing in your *current* directory

- Unit tests unsing [Karma](http://karma-runner.github.io)
- [E2E tests]() using [Protractor](https://github.com/angular/protractor)
- All the code provided ships with tests, we <3 tested code

## Installation
- ```git clone``` this repo
- move into the cloned directory and ```npm link```
- create your project's directory elsewhere ```mkdir ~/dev/my-app && cd $_```
- ```yo vlb```
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