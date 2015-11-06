gulp        = require 'gulp'
forever     = require 'forever'
exec        = require('child_process').exec
coffee      = require 'gulp-coffee'
uglify      = require 'gulp-uglify'
sourcemaps  = require 'gulp-sourcemaps'
del         = require 'del'
env         = require 'gulp-env'

gulp.task '_pull', (done) ->
    exec 'git pull', (err, stdout, stderr) -> 
        console.log stderr if stderr?
        done(err)

gulp.task 'env', ['_pull'], (done) ->
    exec 'npm install', (err, stdout, stderr) -> 
        console.log stderr if stderr?
        done(err)

gulp.task '_build', ['env'], ->
    del ['public/javascripts/dt/*.js']
    .then ->
        gulp.src ['client/*.coffee']
        .pipe coffee()
        .pipe uglify()
        .pipe gulp.dest 'public/javascripts/dt/'

gulp.task '_stop', ['_build'], (done) ->
    forever.stop './app.js'
    .on 'error', (param) -> done()
    .on 'stop', (param) -> done()

gulp.task 'update', ['_stop'], ->
    forever.startDaemon './app.js', logFile: "#{__dirname}/../log/dt_site.log"

gulp.task 'debug_build', ->
    del ['public/javascripts/dt/*.js']
    .then ->
        gulp.src ['client/*.coffee']
        .pipe sourcemaps.init()
        .pipe coffee()
        .pipe sourcemaps.write()
        .pipe gulp.dest 'public/javascripts/dt/'
