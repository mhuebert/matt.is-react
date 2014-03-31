gulp = require("gulp")
notify = require('gulp-notify')
stylus = require('gulp-stylus')
coffee = require('gulp-coffee')
browserify = require('gulp-browserify')
livereload = require('gulp-livereload')
uglify = require('gulp-uglify')
rename = require('gulp-rename')

gulp.task 'stylus', ->
    gulp.src './styles/*.styl'
    .pipe stylus({use: ['nib'], set: ['compress']})
    .pipe(gulp.dest('./public/'))

gulp.task 'scripts', ->
    gulp.src('./app/app.coffee', {read: false})
        .pipe(browserify({
            transform: ['coffeeify', [{'extension': 'coffee'}, 'reactify']]
            extensions: ['.coffee', 'js', '.md']
            noParse: ['jquery', 'underscore']
            ignore: ['firebase']
            }))
        .pipe(rename('app.js'))
        .pipe(gulp.dest('./public/js'))
        # .pipe(uglify())
        # .pipe(rename('app.min.js'))
        # .pipe(gulp.dest('./public/js'))

gulp.task 'watch', ->
    server = livereload()

    gulp.watch('./public/**').on 'change', (file) ->
        server.changed(file.path)

    gulp.watch './styles/**/*.styl', ['stylus']

    gulp.watch './**/*.coffee**', ['scripts']

gulp.task 'default', ->
    gulp.start 'stylus', 'scripts', 'watch'
