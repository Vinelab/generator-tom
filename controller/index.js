'use strict';
var util = require('util');
var yeoman = require('yeoman-generator');

var ControllerGenerator = module.exports = function ControllerGenerator(args, options, config) {
    // By calling `NamedBase` here, we get the argument to the subgenerator call
    // as `this.name`.
    if (typeof args[0] === 'undefined' || args[0] === null)
    {
        throw new Error('Did not provide a feature name');
    }

    yeoman.generators.NamedBase.apply(this, arguments);

    this.bare = options.hasOwnProperty('bare') && options.bare === true;
    this.nofix = options.hasOwnProperty('nofix') && options.nofix === true;

    this.feature = this._.capitalize(this.name);

    // no controller name is specified, we consider the feature
    if (typeof args[1] === 'undefined' || args[1] === null)
    {
        this.controller = this.feature;
    } else {
        this.controller = this._.capitalize(args[1]);
    }

    if ( ! this.nofix)
    {
        this.controller = this.controller + 'Controller';
    }
};

util.inherits(ControllerGenerator, yeoman.generators.NamedBase);

ControllerGenerator.prototype.files = function files() {
    var dir = 'app/src/' + this.feature;
    var location = (this.bare) ? dir : dir + '/controllers';
    var filename = this.controller + '.coffee';

    this.mkdir(dir);
    this.mkdir(location);

    this.template('controller.coffee', location + '/' + filename);
};
