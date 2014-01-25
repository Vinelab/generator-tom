'use strict'

module.exports = (grunt)->

    grunt.option 'app',

    grunt.initConfig

        # timestamp identifying the build
        timestamp: grunt.template.today("ddmmyyyyHHMMss")

        # configure the app's build behavior
        app: {

            # path to the 'app' directory where all the truth is
            path: 'app'
            # path to the tests directory
            tests:
                path: 'tests'
                unit: 'tests/unit'
                e2e: 'tests/e2e'


            # styles settings
            styles:
                path: 'app/assets/styles'

            # build settings
            build:
                dir: 'builds'
                # filename of the bundled source
                filename: 'app'
                # path to the build directory
                path: "builds/<%= timestamp %>"
                # path to the directory that will carry the latest build
                current: 'current'
        }

        # grunt-contrib-watch: watch our files for changes
        watch: {

            # lint source files
            lint_source:
                files: ['**/*.coffee']
                tasks: ['coffeelint']

        }

        # grunt-coffeelint: configuration
        coffeelint: {

            Gruntfile: ['Gruntfile.coffee']
            karma: ['tests/unit/config/karma.conf.coffee']
            source: ['<%= app.path %>/src/**/*.coffee']

            options:
                indentation: level: 'ignore'
                max_line_length: level: 'ignore'

        }

        # grunt-browserify: configuration
        browserify: {
            options:
                transform: ['coffeeify', 'envify', 'brfs']
                aliasMappings: [
                    { # expose the app directory through app/
                        expand: yes
                        cwd: 'app'
                        src: ['**/*.coffee']
                        dest: 'app/'
                    }
                    { # expose source files through src/
                        expand: yes
                        cwd: 'app/src'
                        src: ['**/*.coffee']
                        dest: 'src/'
                    }
                    { # expose vendor files through vendor/
                        cwd: 'vendor'
                        src: ['**/*.js']
                        dest: 'vendor/'
                        flatten: yes
                    }
                ]

            # all the source files
            all:
                src: ['<%= app.path %>/src/App.coffee']
                dest: '<%= app.build.path %>/<%= app.build.filename %>.js'
        }

        uglify: {

            all:
                options: {
                    '-W098': yes
                    compress:
                        global_defs:
                            DEBUG: false
                }

                files: {
                    '<%= app.build.path %>/<%= app.build.filename %>.min.js': ['<%= app.build.path %>/<%= app.build.filename %>.js']
                }

        }

        less: {

            options:
                cleancss: yes
                paths: ['<%= app.styles.path %>']

            files:
                expand: yes
                cwd: '<%= app.styles.path %>'
                src: '*.less'
                ext: '.css'
                dest: '<%= app.build.path %>/styles/'
        }

        shell: {
            webdriver:
                command: 'webdriver-manager start'
                keepalive: yes
                options:
                    stdout: yes
        }

        karma: {

            unit:
                configFile: 'tests/unit/config/karma.conf.coffee'
                singleRun: yes
        }

        protractor: {
            # phantomjs: options: configFile: 'tests/e2e/config/e2e.phantom.js'
            chrome: options: configFile: 'tests/e2e/config/e2e.chrome.js'
            # safari: options: configFile: 'tests/e2e/config/e2e.safari.js'
            # firefox: options: configFile: 'tests/e2e/config/e2e.firefox.js'
        }

        concurrent: {
            options: { logConcurrentOutput: yes }

            test: ['unit-test', 'e2e-test']
            e2e: ['protractor:chrome'] #'protractor:firefox', 'protractor:safari'
            servers: ['shell:webdriver', 'connect:server', 'socket:server']
        }

        coffee: {
            e2etests:
                options:
                    bare: yes
                files:[
                    {
                        expand: yes
                        cwd: '<%= app.tests.e2e %>'
                        src: '**/*.coffee'
                        dest: '<%= app.tests.e2e %>/.js'
                        ext: '.js'
                    }
                ]
        }

        connect: {

            server:
                options:
                    port: 9090
                    hostname: 'localhost' # 0.0.0.0 for external access
                    keepalive: yes
        }

        clean: {

            current:
                files: [
                    {
                        src: ['<%= app.build.current %>/*']
                    }
                ]


            builds:
                files: [
                    {
                        src: ['<%= app.build.dir %>']
                    }
                ]

            e2etests:
                files: [
                    {
                        src: ['<%= app.tests.e2e %>/.js']
                    }
                ]
        }

        # grunt-contrib-copy: configuration
        copy: {
            # copy our latest build to
            # the corresponding current directory
            build:
                files: [
                    {
                        expand: yes
                        nonull: yes
                        cwd: '<%= app.build.path %>'
                        src: ['**/*.js', '**/*.css']
                        dest: '<%= app.build.current %>/'
                    }
                ]

        }

    # add contrib and other tasks
    grunt.loadNpmTasks 'grunt-karma'
    grunt.loadNpmTasks 'grunt-shell'
    grunt.loadNpmTasks 'grunt-concurrent'
    grunt.loadNpmTasks 'grunt-coffeelint'
    grunt.loadNpmTasks 'grunt-browserify'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-less'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-connect'
    grunt.loadNpmTasks 'grunt-protractor-runner'

    # tasks

    # run a socket.io server
    # NB: used to testing/development purposes only
    grunt.registerTask 'socket:server', ->

        # grab hold of the async() method so that grunt
        # doesn't end this process unless told to
        cb = @async()

        io = require('socket.io').listen 9091

        io.set('log level', 2)

        io.sockets.on 'connection', (socket)->

            grunt.log.subhead 'socket'
            grunt.log.ok('connection esatblished successfully')

            socket.emit 'connection:established'
            socket.on 'disconnect', ->
                grunt.log.subhead 'socket'
                grunt.log.error('disconnected')

    # run everything sequentially
    grunt.registerTask 'default:begin', ->
        grunt.log.subhead 'Making the Awesome...'
        grunt.log.oklns 'Builds will live in <%= app.build.path %>'
        grunt.log.oklns 'Current version of the running app will be in <%= app.build.current %>'

    grunt.registerTask 'default:end', -> grunt.log.subhead 'That\'s it for now!'

    grunt.registerTask 'default', ['default:begin', 'coffeelint', 'browserify', 'uglify', 'less', 'clean:current', 'copy', 'test', 'default:end']

    # serve the application
    grunt.registerTask 'serve', ->
        grunt.log.subhead 'development server'
        grunt.log.ok 'http://localhost:9090'

        grunt.log.subhead 'socket server'
        grunt.log.ok 'http://localhost:9091'

        grunt.log.subhead 'testing server'
        grunt.log.writeln 'chrome webdriver (selenium) using port 4444'
        grunt.log.ok 'visit http://localhost:4444/wd/hub to mess around with browser sessions.'

        grunt.task.run 'concurrent:servers'

    # build the project for development (skips minifying code)
    grunt.registerTask 'build-dev', ['coffeelint', 'browserify', 'less', 'clean:current', 'copy']

    # run end-to-end tests http://docs.angularjs.org/guide/dev_guide.e2e-testing
    grunt.registerTask 'e2e-test', ['clean:e2etests', 'coffee:e2etests', 'concurrent:e2e', 'clean:e2etests']

    # run unit tests http://docs.angularjs.org/guide/dev_guide.unit-testing
    grunt.registerTask 'unit-test', ['karma']

    # run all tests
    grunt.registerTask 'test', ['concurrent:test']