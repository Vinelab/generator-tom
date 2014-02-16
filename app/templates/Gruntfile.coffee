'use strict'

fs = require 'fs'

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

        # set configuration parameters globally
        set_app: grunt.config.set('app', '<% app %>')
        set_timestamp: grunt.config.set('timestamp', '<% timestamp %>')

        # grunt-contrib-watch: watch our files for changes
        watch: {

            # lint source files
            lint_source:
                files: ['**/*.coffee']
                tasks: ['coffeelint']

        }

        # grunt-coffeelint: lint it
        coffeelint: {

            Gruntfile: ['Gruntfile.coffee']
            karma: ['tests/unit/config/karma.conf.coffee']
            source: ['<%= app.path %>/src/**/*.coffee']

            options:
                indentation: level: 'ignore'
                max_line_length: level: 'ignore'

        }

        # grunt-browserify: commonjs magic
        browserify: {
            options:
                transform: ['coffeeify', 'envify', 'brfs']
            # all the source files
            all:
                options:
                    alias: [
                        'app/routes.coffee:routes'
                        'app/filters.coffee:filters'
                        'lib/CDN/CDN.coffee:CDN'
                        'lib/Config/Config.coffee:Config'
                        'lib/Socket/Socket.coffee:Socket'
                        'lib/Storage/StorageService.coffee:Storage'
                        'app/src/Main/controllers/MainController.coffee:MainController'
                    ]
                    aliasMappings: [
                        {
                            expand: yes
                            cwd: 'lib'
                            src: ['Storage/**/*.coffee', 'Socket/**/*.coffee']
                            dest: 'lib/'
                        }
                    ]
                src: ['<%= app.path %>/src/App.coffee']
                dest: '<%= app.build.path %>/<%= app.build.filename %>.js'
        }
        # grunt-contrib-uglify: make things look uglier than they are
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
        # grunt-contrib-less: css pre-processor
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
        # grunt-shell: some cool commands
        shell: {
            # start chrome driver
            webdriver:
                command: 'webdriver-manager start'
                keepalive: yes
                options: stdout: yes
            # mark the current build with a stamp in `current`/.build file
            mark: command: 'echo <%= timestamp %> > <%= app.build.current %>/.build'
        }
        # grunt-karma: it's a bitch!
        karma: {

            unit:
                configFile: 'tests/unit/config/karma.conf.coffee'
                singleRun: yes
        }
        # grunt-protractor-runner: chrome's webdriver
        protractor: {
            # phantomjs: options: configFile: 'tests/e2e/config/e2e.phantom.js'
            chrome: options: configFile: 'tests/e2e/config/e2e.chrome.js'
            # safari: options: configFile: 'tests/e2e/config/e2e.safari.js'
            # firefox: options: configFile: 'tests/e2e/config/e2e.firefox.js'
        }
        # grunt-concurrent: run tasks in parallel
        concurrent: {
            options: { logConcurrentOutput: yes }

            test: ['unit-test', 'e2e-test']
            e2e: ['protractor:chrome'] #'protractor:firefox', 'protractor:safari'
            servers: ['shell:webdriver', 'connect:server', 'socket:server']
        }
        # grunt-contrib-coffee: compile coffeescript
        # files to javascript for e2e testing
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
        # grunt-contrib-connect: static web server
        connect: {

            server:
                options:
                    port: 9090
                    hostname: 'localhost' # 0.0.0.0 for external access
                    keepalive: yes
        }
        # grunt-contrib-clean: cleanup stuff
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

        # grunt-contrib-copy: copy source files
        copy: {
            # copy our latest build to
            # the corresponding current directory
            # with some angular dependencies
            current:
                files: [
                    { # source files
                        expand: yes
                        nonull: yes
                        cwd: '<%= app.build.path %>'
                        src: ['**/*.js', '**/*.css']
                        dest: '<%= app.build.current %>/'
                    }
                    {# angularjs
                        src: 'vendor/angular/angular.min.js'
                        dest: '<%= app.build.current %>/vendor/angular.min.js'
                    }
                    {# angularjs map
                        src: 'vendor/angular/angular.min.js.map'
                        dest: '<%= app.build.current %>/vendor/angular.min.js.map'
                    }
                    {# angularjs route
                        src: 'vendor/angular-route/angular-route.min.js'
                        dest: '<%= app.build.current %>/vendor/angular-route.min.js'
                    }
                    {# angularjs route map
                        src: 'vendor/angular-route/angular-route.min.js.map'
                        dest: '<%= app.build.current %>/vendor/angular-route.min.js.map'
                    }
                    {# angularjs cookies
                        src: 'vendor/angular-cookies/angular-cookies.min.js.map'
                        dest: '<%= app.build.current %>/angular-cookies.min.js.map'
                    }
                ]

            build:
                files: [
                    {
                        expand: yes
                        nonull: yes
                        cwd: '<%= app.build.dir%>/<%= timestamp %>'
                        src: ['**/*.js', '**/*.css']
                        dest: '<%= app.build.current %>/'
                    }
                ]

        }
        # grunt-aws: aws s3 deployment
        s3: {
            options:
                bucket: '<%= aws.s3.bucket %>'
                accessKeyId: '<%= aws.s3.key %>'
                secretAccessKey: '<%= aws.s3.secret %>'
                # preview deployment
                # dryRun: yes

            current:
                cwd: 'current/'
                src: '**'

            views:
                cwd: 'app/views/'
                src: '**'
        }

    # add contrib and other tasks
    grunt.loadNpmTasks 'grunt-aws'
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

    grunt.registerTask 'default', [
                            'default:begin'
                            'coffeelint'
                            'browserify'
                            'uglify'
                            'less'
                            'clean:current'
                            'copy:current'
                            'test'
                            'shell:mark'
                            'default:end'
                        ]

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
    grunt.registerTask 'build-dev', [
                                'coffeelint'
                                'browserify'
                                'less'
                                'clean:current'
                                'copy:current'
                                'shell:mark'
                            ]

    # run end-to-end tests http://docs.angularjs.org/guide/dev_guide.e2e-testing
    grunt.registerTask 'e2e-test', ['clean:e2etests', 'coffee:e2etests', 'concurrent:e2e', 'clean:e2etests']

    # run unit tests http://docs.angularjs.org/guide/dev_guide.unit-testing
    grunt.registerTask 'unit-test', ['karma']

    # run all tests
    grunt.registerTask 'test', ['concurrent:test']

    # deploy to aws s3
    grunt.registerTask 'deploy:aws', ['s3']

    # list all builds
    grunt.registerTask 'list', ->
        # get the app configuration
        app = grunt.config.get('app')
        # read builds from filesystem
        builds = getAllBuilds(app)
        current = getCurrentBuild(app)

        # print builds
        for build in builds
            if build is current then grunt.log.ok(build) else grunt.log.writeln(build)

    # checkout a build (make it the current one)
    grunt.registerTask 'checkout', ['Checkout a build of your choice'], (build)->
        throw new Error('Please specify the build you are targeting.') if not build

        # helper steps that can be used after checkout:<step>
        stepping = false # initially we assume they're not taking a step
        steps = ['first', 'last', 'prev', 'next']

        # get the app configuration
        app = grunt.config.get('app')

        if (steps.indexOf(build) > -1) # is it a step what they meant ?
            stepping = yes
        else if not fs.existsSync("#{app.build.dir}/#{build}")  # look for the claimed build
            message = "Build '#{build}' does not exist."
            grunt.log.error(message)
            grunt.log.writeln()
            grunt.log.writeln('Use "grunt list" to check them out.')
            grunt.log.writeln()
            # oh no, we hope it's a typo
            throw new Error(message)

        build = getStepBuild(app, build) if stepping

        grunt.log.subhead "Checking out #{build}"

        # set the build as the current timestamp
        grunt.config.set('timestamp', build)
        # checkout
        grunt.task.run 'clean:current'
        grunt.task.run 'copy:build'
        grunt.task.run 'shell:mark'

getAllBuilds = (config)-> fs.readdirSync(config.build.dir)

getCurrentBuild = (config)-> fs.readFileSync("#{config.build.current}/.build")
                            .toString().split('\n')[0]
getStepBuild = (config, step)->

    builds = getAllBuilds(config)

    switch step
        when 'first' then builds[0]
        when 'last' then builds[builds.length - 1]
        when 'prev'
            unless builds.indexOf(getCurrentBuild(config)) is 0
                return builds[builds.indexOf(getCurrentBuild(config)) - 1]
            throw new Error('Already on earliest build.')
        when 'next'
            unless builds.indexOf(getCurrentBuild(config)) is (builds.length - 1)
                return builds[builds.indexOf(getCurrentBuild(config)) + 1]
            throw new Error('Already on last build.')
        else throw new Error("Unknown step #{step}")
