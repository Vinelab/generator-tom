'use strict';
var util = require('util');
var yeoman = require('yeoman-generator');

var ProviderGenerator = module.exports = function ProviderGenerator(args, options, config) {
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

    // when no provider name is specified we consider the feature name
    if (typeof args[1] === 'undefined' || args[1] === null)
    {
        this.provider = this.feature;
    } else {
        this.provider = this._.capitalize(args[1]);
    }

    if ( ! this.nofix)
    {
        this.provider = this.provider + 'Provider';
    }
};

util.inherits(ProviderGenerator, yeoman.generators.NamedBase);

ProviderGenerator.prototype.files = function files() {
    var dir = 'app/src/' + this.feature;
    var location = (this.bare) ? dir : dir + '/providers';
    var filename = this.provider + '.coffee';

    this.mkdir(dir);
    this.mkdir(location);

    this.template('provider.coffee', location + '/' + filename);
};
