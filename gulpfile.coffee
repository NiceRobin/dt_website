gulp        = require 'gulp'
forever     = require 'forever'
exec        = require('child_process').exec
coffee      = require 'gulp-coffee'
uglify      = require 'gulp-uglify'
sourcemaps  = require 'gulp-sourcemaps'
del         = require 'del'
env         = require 'gulp-env'
coffeeify   = require 'gulp-coffeeify'

gulp.task '_pull', (done) ->
    exec 'git pull', (err, stdout, stderr) -> 
        console.log stderr if stderr?
        done(err)

gulp.task '_stop', ['_pull'], (done) ->
    forever.stop './app.js'
    .on 'error', (param) -> done()
    .on 'stop', (param) -> done()

gulp.task '_debug_build', ->
    del ['public/javascripts/dt/*.js']
    .then ->
        gulp.src ['client/*.coffee']
        .pipe sourcemaps.init()
        .pipe coffee()
        .pipe sourcemaps.write()
        .pipe gulp.dest 'public/javascripts/dt/'

        gulp.src ['apx3d/apx3d.coffee']
        .pipe coffeeify(options: debug: true)
        .pipe gulp.dest 'public/javascripts/dt/'

gulp.task '_build', ->
    del ['public/javascripts/dt/*.js']
    .then ->
        gulp.src ['client/*.coffee']
        .pipe coffee()
        .pipe uglify()
        .pipe gulp.dest 'public/javascripts/dt/'

        gulp.src ['apx3d/apx3d.coffee']
        .pipe coffeeify()
        .pipe uglify()
        .pipe gulp.dest 'public/javascripts/dt/'

gulp.task 'update', ['_stop', '_build'], ->
    forever.startDaemon './app.js', logFile: "#{__dirname}/../log/dt_site.log"
