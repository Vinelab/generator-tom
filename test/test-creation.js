/*global describe, beforeEach, it*/
'use strict';

var path    = require('path');
var helpers = require('yeoman-generator').test;
var exec = require('child_process').exec;

describe('tom generator', function () {
    beforeEach(function (done) {
        helpers.testDirectory(path.join(__dirname, 'temp'), function (err) {
            if (err) {
                return done(err);
            }

            this.app = helpers.createGenerator('tom:app', [
                '../../app'
            ]);
            done();
        }.bind(this));
    });

    it('creates expected files', function (done) {
        var expected = [
            // add files you expect to exist here.
            'app/filters.coffee',
            'app/routes.coffee',
            'app/boot/start.coffee',
            'app/views/main.html',
            'app/config/default.yml',
            'app/config/development.yml',
            'app/config/production.yml',
            'app/assets/styles/base.less',
            'app/src/App.coffee',
            'app/src/Config/Config.coffee',
            'app/src/Main/controllers/MainController.coffee',
            'app/src/Storage/StorageService.coffee',
            'app/src/Socket/io.coffee',
            'app/src/Socket/Socket.coffee',
            '.bowerrc', 'Gruntfile.coffee', '.gitignore', 'index.html',
            'tests/unit/config/karma.conf.coffee',
            'tests/unit/Socket/SocketTest.coffee',
            'tests/unit/Main/controllers/MainControllerTest.coffee',
            'tests/e2e/config/e2e.chrome.js', 'tests/e2e/config/e2e.firefox.js',
            'tests/e2e/config/e2e.phantom.js', 'tests/e2e/config/e2e.safari.js',
            'tests/e2e/mainTest.coffee'
        ];

        helpers.mockPrompt(this.app, {
            // 'someOption': true
        });
        this.app.options['skip-install'] = true;
        this.app.run({}, function () {
            helpers.assertFiles(expected);
            exec('rm -rf ' + path.join(__dirname, 'temp'), function (err, out) {
                console.log(out); err && console.error(err);
                done();
            });
        });
    });
});
