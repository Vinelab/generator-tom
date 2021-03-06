/*global describe, beforeEach, it*/
'use strict';

var path    = require('path');
var helpers = require('yeoman-generator').test;
var exec = require('child_process').exec;

describe('tom:service generator', function () {

    beforeEach(function (done) {
        helpers.testDirectory(path.join(__dirname, 'temp'), function (err) {
            if (err) {
                return done(err);
            }

            done();
        }.bind(this));

        this.clean = function (done) {
            exec('rm -rf ' + path.join(__dirname, 'temp'), function (err, out) {
                console.log(out); err && console.error(err);
                done();
            });
        };
    });

    it ('creates files with the feature name, postfix and sub directories', function (done) {
        var app = helpers.createGenerator('tom:service', ['../../../service'], ['Api']);
        app.options['skip-install'] = true;

        var expected = [
           'app/src/Api/services/ApiService.coffee'
        ];

        app.run({}, function () {
            helpers.assertFiles(expected);
            this.clean(done);
        }.bind(this));

    });

    it ('creates files directly in feature directory when --bare', function (done) {
        var app = helpers.createGenerator('tom:service', ['../../../service'], ['Api'], {
            'bare': true
        });

        app.options['skip-install'] = true;

        var expected = ['app/src/Api/ApiService.coffee'];

        app.run({}, function () {
            helpers.assertFiles(expected);
            this.clean(done);
        }.bind(this));
    });

    it ('skips pre and postfixing file names with --nofix', function (done) {
        var app = helpers.createGenerator('tom:service', ['../../../service'], ['Api'], {
            'nofix': true
        });

        app.options['skip-install'] = true;

        var expected = ['app/src/Api/services/Api.coffee'];

        app.run({}, function () {
            helpers.assertFiles(expected);
            this.clean(done);
        }.bind(this));
    });

    it ('accepts and considers both --bare and --nofix together', function (done) {
        var app = helpers.createGenerator('tom:service', ['../../../service'], ['Api'], {
            'nofix': true,
            'bare': true
        });

        app.options['skip-install'] = true;

        var expected = ['app/src/Api/Api.coffee'];

        app.run({}, function () {
            helpers.assertFiles(expected);
            this.clean(done);
        }.bind(this));

    });

    it ('accepts a custom service name', function (done) {
        var app = helpers.createGenerator('tom:service', ['../../../service'], ['Api', 'authorization']);
        app.options['skip-install'] = true;

        var expected = ['app/src/Api/services/AuthorizationService.coffee'];

        app.run({}, function () {
            helpers.assertFiles(expected);
            this.clean(done);
        }.bind(this));
    });

});
