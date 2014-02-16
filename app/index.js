'use strict';
var util = require('util');
var path = require('path');
var yeoman = require('yeoman-generator');


var VinelabGenerator = module.exports = function VinelabGenerator(args, options, config) {
    yeoman.generators.Base.apply(this, arguments);

    this.on('end', function () {
        this.installDependencies({
            skipInstall: options['skip-install'],
            callback: function () {
                this.spawnCommand('./node_modules/.bin/webdriver-manager', ['update']);
            }.bind(this)
        });
    });

    this.pkg = JSON.parse(this.readFileAsString(path.join(__dirname, '../package.json')));
};

util.inherits(VinelabGenerator, yeoman.generators.Base);

VinelabGenerator.prototype.askFor = function askFor() {
    var cb = this.async();

    // have Yeoman greet the user.
    console.log(this.yeoman);

    var prompts = [
        {
            name: 'name',
            message: 'Name your app (this will be the module name as well)',
        },
        {
            name: 'description',
            message: 'Describe it for us',
        }
    ];

    this.prompt(prompts, function (props) {
        this.customize = props.customize;
        this.name = props.name;
        this.description = props.description;

        cb();
    }.bind(this));
};

VinelabGenerator.prototype.app = function app() {

    this.mkdir('app');
};

VinelabGenerator.prototype.views = function views() {
    this.mkdir('app/views');
    this.copy('app/views/main.html', 'app/views/main.html');
};

VinelabGenerator.prototype.config = function config() {
    this.mkdir('app/config');

    this.copy('app/config/default.yml', 'app/config/default.yml');
    this.copy('app/config/development.yml', 'app/config/development.yml');
    this.copy('app/config/production.yml', 'app/config/production.yml');
};

VinelabGenerator.prototype.assets = function assets() {
    this.mkdir('app/assets');
    this.mkdir('app/assets/styles');

    this.copy('app/assets/styles/base.less', 'app/assets/styles/base.less');
};

VinelabGenerator.prototype.routesAndFilters = function routesAndFilters() {
    this.copy('app/routes.coffee', 'app/routes.coffee');
    this.copy('app/filters.coffee', 'app/filters.coffee');
};

VinelabGenerator.prototype.sourcefiles = function sourcefiles() {
    this.mkdir('app/src');
    this.mkdir('app/src/Main');
    this.mkdir('app/src/Config');
    this.mkdir('app/src/CDN');
    this.mkdir('app/src/Socket');
    this.mkdir('app/src/Storage');

    this.copy('app/src/App.coffee', 'app/src/App.coffee');
    this.copy('app/src/Config/Config.coffee', 'app/src/Config/Config.coffee');
    this.copy('app/src/CDN/CDN.coffee', 'app/src/CDN/CDN.coffee');
    this.copy('app/src/Main/controllers/MainController.coffee', 'app/src/Main/controllers/MainController.coffee');
    this.template('app/src/Storage/StorageService.coffee', 'app/src/Storage/StorageService.coffee');
    this.copy('app/src/Socket/factories/io.coffee', 'app/src/Socket/factories/io.coffee');
    this.copy('app/src/Socket/services/SocketService.coffee', 'app/src/Socket/services/SocketService.coffee');
    this.copy('app/src/Socket/SocketConnection.coffee', 'app/src/Socket/SocketConnection.coffee');
    this.copy('app/src/Socket/Socket.coffee', 'app/src/Socket/Socket.coffee');
};

VinelabGenerator.prototype.deps = function deps() {
    this.template('_bower.json', 'bower.json');
    this.template('_package.json', 'package.json');

    this.copy('bowerrc', '.bowerrc');
    this.copy('Gruntfile.coffee', 'Gruntfile.coffee');
    this.template('aws.json', 'aws.json');
};

VinelabGenerator.prototype.projectfiles = function projectfiles() {
    this.copy('gitignore', '.gitignore');
    this.template('index.html', 'index.html');
};

VinelabGenerator.prototype.tests = function tests() {
    this.mkdir('tests');
    // unit tests
    this.mkdir('tests/unit');
    this.mkdir('tests/unit/config');
    this.mkdir('tests/unit/Main/controllers');
    this.mkdir('tests/unit/Socket');

    this.copy('tests/unit/config/karma.conf.coffee', 'tests/unit/config/karma.conf.coffee');
    this.template('tests/unit/Socket/SocketTest.coffee', 'tests/unit/Socket/SocketTest.coffee');
    this.template('tests/unit/Socket/SocketConnectionTest.coffee', 'tests/unit/Socket/SocketConnectionTest.coffee');
    this.template('tests/unit/Main/controllers/MainControllerTest.coffee', 'tests/unit/Main/controllers/MainControllerTest.coffee');
    this.template('tests/unit/CDN/CDNTest.coffee', 'tests/unit/CDN/CDNTest.coffee');

    // e2e tests
    this.mkdir('tests/e2e');
    this.mkdir('tests/e2e/config');
    // browsers configs
    this.copy('tests/e2e/config/e2e.chrome.js', 'tests/e2e/config/e2e.chrome.js');
    this.copy('tests/e2e/config/e2e.firefox.js', 'tests/e2e/config/e2e.firefox.js');
    this.copy('tests/e2e/config/e2e.phantom.js', 'tests/e2e/config/e2e.phantom.js');
    this.copy('tests/e2e/config/e2e.safari.js', 'tests/e2e/config/e2e.safari.js');

    this.copy('tests/e2e/mainTest.coffee', 'tests/e2e/mainTest.coffee');
};