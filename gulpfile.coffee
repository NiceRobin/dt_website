gulp    = require 'gulp'
forever = require 'forever'
exec    = require('child_process').exec

gulp.task '_pull', (done) ->
    exec 'git pull', (err, stdout, stderr) -> 
        console.log stderr if stderr?
        done(err)

gulp.task '_stop', ['_pull'], (done) ->
    forever.stop './app.js'
    .on 'error', (param) -> done()
    .on 'stop', (param) -> done()

gulp.task 'update', ['_stop'], ->
    forever.startDaemon './app.js', logFile: "#{__dirname}/../log/dt_site.log"
    