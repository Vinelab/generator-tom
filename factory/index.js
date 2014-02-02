'use strict';
var util = require('util');
var yeoman = require('yeoman-generator');

var FactoryGenerator = module.exports = function FactoryGenerator(args, options, config) {
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

    // no factory name is specified, we consider the feature
    if (typeof args[1] === 'undefined' || args[1] === null)
    {
        this.factory = this.feature;
    } else {
        this.factory = this._.capitalize(args[1]);
    }

    if ( ! this.nofix)
    {
        this.factory = this.factory + 'Factory';
    }

    console.log('You called the factory subgenerator with the argument ' + this.name + '.');
};

util.inherits(FactoryGenerator, yeoman.generators.NamedBase);

FactoryGenerator.prototype.files = function files() {
    var dir = 'app/src/' + this.feature;
    var location = (this.bare) ? dir : dir + '/factories';
    var filename = this.factory + '.coffee';

    this.mkdir(dir);
    this.mkdir(location);

    this.template('factory.coffee', location + '/' + filename);
};
