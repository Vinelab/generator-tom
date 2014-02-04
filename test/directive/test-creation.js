/*global describe, beforeEach, it*/
'use strict';

var path    = require('path');
var helpers = require('yeoman-generator').test;
var exec = require('child_process').exec;

describe('tom:directive generator', function () {

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

    it ('creates files with the feature name and sub directories', function (done) {
        var app = helpers.createGenerator('tom:directive', ['../../../directive'], ['customers']);
        app.options['skip-install'] = true;

        var expected = [
           'app/src/Customers/directives/customers.coffee'
        ];

        app.run({}, function () {
            helpers.assertFiles(expected);
            this.clean(done);
        }.bind(this));
    });

    it ('creates files directly in feature directory when --bare', function (done) {
        var app = helpers.createGenerator('tom:directive', ['../../../directive'], ['customers'], {
            'bare': true
        });

        app.options['skip-install'] = true;

        var expected = ['app/src/Customers/customers.coffee'];

        app.run({}, function () {
            helpers.assertFiles(expected);
            this.clean(done);
        }.bind(this));
    });

    it ('accepts a custom directive name', function (done) {
        var app = helpers.createGenerator('tom:directive', ['../../../directive'], ['customers', 'myCustomer']);
        app.options['skip-install'] = true;

        var expected = ['app/src/Customers/directives/myCustomer.coffee'];

        app.run({}, function () {
            helpers.assertFiles(expected);
            this.clean(done);
        }.bind(this));
    });

});
