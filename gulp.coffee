gulp = require("gulp")
gutil = require("gulp-util")
notify = require('gulp-notify')
stylus = require('gulp-stylus')
coffee = require('gulp-coffee')
browserify = require('gulp-browserify')
livereload = require('gulp-livereload')
uglify = require('gulp-uglify')
rename = require('gulp-rename')
spawn = require('child_process').spawn
mergeFirebaseRules = require("merge-firebase-rules")


gulp.task 'stylus', ->
    gulp.src './app/styles/*.styl'
    .pipe stylus({use: ['nib'], set: ['compress']})
    .pipe(gulp.dest('./app/public/styles'))

gulp.task 'scripts', ->
    gulp.src('./app/app.coffee', {read: false})
        .pipe(browserify({
            ignore: ['firebase', 'firebase-util']
            transform: ['coffee-reactify']
            extensions: ['.cjsx', '.coffee', '.js', '.md']
            noParse: ['jquery', 'underscore']
            }))
        .pipe(rename('app.js'))
        # .pipe(uglify())
        .pipe(gulp.dest('./app/public/js'))
        # .pipe(rename('app.min.js'))
        # .pipe(gulp.dest('./public/js'))

gulp.task 'firebaseRules', ->
    if mergeFirebaseRules("./app/security-rules", "./app/security-rules/_compiled.json")
        console.log "...Deploying Firebase rules"
        firebase = spawn "firebase", ['deploy']
        firebase.stdout.on 'data', (data) -> gutil.log data.toString().trim()
        # receive error messages and process
        firebase.stderr.on 'data', (data) -> gutil.log data.toString().trim()
    else
        gutil.log "Error merging Firebase rules"

gulp.task 'watch', ->
    server = livereload()

    gulp.watch('./app/public/**').on 'change', (file) ->
        server.changed(file.path)

    gulp.watch './app/styles/**/*.styl', ['stylus']

    gulp.watch './**/*.coffee**', ['scripts']
    gulp.watch './**/*.cjsx**', ['scripts']

    gulp.watch './app/security-rules/rules/**/*', ['firebaseRules']

gulp.task 'default', ->
    gulp.start 'stylus', 'scripts', 'firebaseRules', 'watch'
