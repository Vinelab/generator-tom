# VLB Yeoman Generator - AngularJS

## Features

### Source Linting
- CoffeeScript source code linting
### Configuration
- Environment-based configuration provided through a ```Config``` class
- Modify configuration attribtues at runtime
### Built-in Servers
- Development server that runs on localhost:9000
- Testing server using [Google Chrome's webdriver](https://code.google.com/p/selenium/wiki/ChromeDriver) ([Selenium](http://docs.seleniumhq.org))
### Build Versioning
- Keep builds history
- Latest build is copied to its own directory
- Navigate and Checkout build versions *(work in progress)*
### Assets
- Compiled Javascript with [Browserify](http://browserify.org)
- Minified Javascript with [UglifyJS](https://github.com/mishoo/UglifyJS)
- [LESS](http://www.lesscss.org) CSS pre-processor
- Minified CSS with [clean-css](https://github.com/GoalSmashers/clean-css)

## Installation
- install [yeoman](http://yeoman.io) ```npm install -g yo```
- ```git clone``` this repo
- move into the cloned directory and ```npm link```
- create your project's directory elsewhere ```mkdir ~/dev/my-app && cd $_```
- ```yo vlb```
- in another terminal session run ```grunt serve```
- ```grunt``` and you're done