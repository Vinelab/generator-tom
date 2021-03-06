module.exports = (config)->

    config.set

        # base path, that will be used to resolve files and excludes
        basePath: '../../../',

        # testing framework to use (jasmine/mocha/qunit/...)
        frameworks: ['jasmine'],

        # list of files / patterns to load in the browser
        files: [
            'current/vendor/angular.min.js'
            'current/vendor/angular-route.min.js'
            'vendor/angular-mocks/angular-mocks.js'
            'current/app.js',
            'tests/unit/**/*Test.coffee',
        ],

        # list of files and patterns to exclude
        exclude: [],

        # test results reporter to use
        # possible values: 'dots', 'progress', 'junit', 'growl', 'coverage'
        reporters: ['dots'],

        # web server port
        port: 6678,

        # enable / disable colors in the output (reporters and logs)
        colors: true,

        # level of logging
        # possible values: LOG_DISABLE || LOG_ERROR || LOG_WARN || LOG_INFO || LOG_DEBUG
        logLevel: config.LOG_INFO,


        # enable / disable watching file and executing tests whenever any file changes
        autoWatch: false,


        # Start these browsers, currently available:
        # - Chrome
        # - ChromeCanary
        # - Firefox
        # - Opera
        # - Safari (only Mac)
        # - PhantomJS
        # - IE (only Windows)
        browsers: ['PhantomJS']

        # If browser does not capture in given timeout [ms], kill it
        captureTimeout: 60000,

        # Continuous Integration mode
        # if true, it capture browsers, run tests and exit
        singleRun: false