/*global describe, beforeEach, it*/
'use strict';

var path    = require('path');
var helpers = require('yeoman-generator').test;
var exec = require('child_process').exec;

describe('vlb:factory generator', function () {

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
        var app = helpers.createGenerator('vlb:factory', ['../../../factory'], ['Chocolate']);
        app.options['skip-install'] = true;

        var expected = [
           'app/src/Chocolate/factories/ChocolateFactory.coffee'
        ];

        app.run({}, function () {
            helpers.assertFiles(expected);
            this.clean(done);
        }.bind(this));

    });

    it ('creates files directly in feature directory when --bare', function (done) {
        var app = helpers.createGenerator('vlb:factory', ['../../../factory'], ['Chocolate'], {
            'bare': true
        });

        app.options['skip-install'] = true;

        var expected = ['app/src/Chocolate/ChocolateFactory.coffee'];

        app.run({}, function () {
            helpers.assertFiles(expected);
            this.clean(done);
        }.bind(this));
    });

    it ('skips pre and postfixing file names with --nofix', function (done) {
        var app = helpers.createGenerator('vlb:factory', ['../../../factory'], ['Chocolate'], {
            'nofix': true
        });

        app.options['skip-install'] = true;

        var expected = ['app/src/Chocolate/factories/Chocolate.coffee'];

        app.run({}, function () {
            helpers.assertFiles(expected);
            this.clean(done);
        }.bind(this));
    });

    it ('accepts and considers both --bare and --nofix together', function (done) {
        var app = helpers.createGenerator('vlb:factory', ['../../../factory'], ['Chocolate'], {
            'nofix': true,
            'bare': true
        });

        app.options['skip-install'] = true;

        var expected = ['app/src/Chocolate/Chocolate.coffee'];

        app.run({}, function () {
            helpers.assertFiles(expected);
            this.clean(done);
        }.bind(this));

    });

    it ('accepts a custom factory name', function (done) {
        var app = helpers.createGenerator('vlb:factory', ['../../../factory'], ['Chocolate', 'milk']);
        app.options['skip-install'] = true;

        var expected = ['app/src/Chocolate/factories/MilkFactory.coffee'];

        app.run({}, function () {
            helpers.assertFiles(expected);
            this.clean(done);
        }.bind(this));
    });

});
