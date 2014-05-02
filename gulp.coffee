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
{mergeFirebaseRules} = require("sparkboard-tools")

gulp.task 'stylus', ->
    gulp.src './styles/*.styl'
    .pipe stylus({use: ['nib'], set: ['compress']})
    .pipe(gulp.dest('./public/'))

gulp.task 'scripts', ->
    gulp.src('./app/app.coffee', {read: false})
        .pipe(browserify({
            ignore: ['firebase', 'firebase-util']
            transform: ['coffeeify', [{'extension': 'coffee'}, 'reactify']]
            extensions: ['.coffee', 'js', '.md']
            noParse: ['jquery', 'underscore']
            }))
        .pipe(rename('app.js'))
        .pipe(gulp.dest('./public/js'))
        # .pipe(uglify())
        # .pipe(rename('app.min.js'))
        # .pipe(gulp.dest('./public/js'))

gulp.task 'firebaseRules', ->
    if mergeFirebaseRules("./security-rules", "./security-rules/_compiled.json")
        console.log "...Deploying Firebase rules"
        firebase = spawn "firebase", ['deploy']
        firebase.stdout.on 'data', (data) -> gutil.log data.toString().trim()
        # receive error messages and process
        firebase.stderr.on 'data', (data) -> gutil.log data.toString().trim()
    else
        gutil.log "Error merging Firebase rules"

gulp.task 'watch', ->
    server = livereload()

    gulp.watch('./public/**').on 'change', (file) ->
        server.changed(file.path)

    gulp.watch './styles/**/*.styl', ['stylus']

    gulp.watch './**/*.coffee**', ['scripts']

    gulp.watch './security-rules/rules/**/*', ['firebaseRules']

gulp.task 'default', ->
    gulp.start 'stylus', 'scripts', 'firebaseRules', 'watch'
