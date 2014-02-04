'use strict';
var util = require('util');
var yeoman = require('yeoman-generator');

var DirectiveGenerator = module.exports = function DirectiveGenerator(args, options, config) {
    // By calling `NamedBase` here, we get the argument to the subgenerator call
    // as `this.name`.

    // support default options
    if (typeof args[0] === 'undefined' || args[0] === null)
    {
        throw new Error('Did not provide a feature name');
    }

    yeoman.generators.NamedBase.apply(this, arguments);

    this.bare = options.hasOwnProperty('bare') && options.bare === true;

    this.feature = this._.capitalize(this.name);

    // name the directive
    if (typeof args[1] === 'undefined' || args[1] === null)
    {
        this.directive = this._.camelize(this.name);
    } else {
        this.directive = this._.camelize(args[1]);
    }

    this.restrict = options.hasOwnProperty('restrict') ? options.restrict : 'EA';

    this.controller = options.hasOwnProperty('controller') ? options.controller : false;

    if (this.controller)
    {
        this.controller = (this.controller === true) ? this._.capitalize(this.directive) + 'Controller'
            : this._.capitalize(this.controller) + 'Controller';
    }

    this.templateUrl = options.hasOwnProperty('templateUrl') ? options.templateUrl : false;

    if (this.templateUrl === true) // if they only chose to have a template URL
    {
        this.templateUrl = 'app/views/' + this._.slugify(this.directive) + '.html';
    }

    this.transclude = options.hasOwnProperty('transclude') && options.transclude === true;

};

util.inherits(DirectiveGenerator, yeoman.generators.NamedBase);

DirectiveGenerator.prototype.files = function files() {
    var dir = 'app/src/' + this.feature;
    var location = (this.bare) ? dir : dir + '/directives';
    var filename = this.directive + '.coffee';

    this.mkdir(dir);
    this.mkdir(location);

    this.template('directive.coffee', location + '/' + filename);

    if (this.templateUrl)
    {
        this.copy('template.html', this.templateUrl);
    }
};
