gulp        = require 'gulp'
forever     = require 'forever'
exec        = require('child_process').exec
coffee      = require 'gulp-coffee'
concat      = require 'gulp-concat'
uglify      = require 'gulp-uglify'
sourcemaps  = require 'gulp-sourcemaps'
del         = require 'del'

gulp.task '_pull', (done) ->
    exec 'git pull', (err, stdout, stderr) -> 
        console.log stderr if stderr?
        done(err)

gulp.task '_stop', ['_pull'], (done) ->
    forever.stop './app.js'
    .on 'error', (param) -> done()
    .on 'stop', (param) -> done()

gulp.task '_build', ->
    del ['public/javascripts/dt.js']
    .then ->
        gulp.src ['client/*.coffee']
        # .pipe sourcemaps.init()
        .pipe coffee()
        .pipe uglify()
        # .pipe concat 'all.min.js'
        # .pipe sourcemaps.write()
        .pipe gulp.dest 'public/javascripts/'

gulp.task 'update', ['_stop', '_build'], ->
    forever.startDaemon './app.js', logFile: "#{__dirname}/../log/dt_site.log"
