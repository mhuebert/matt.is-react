// Using Gulp with coffeescript

require('coffee-script/register');
var gutil = require('gulp-util');
var gulpfile = 'gulp.coffee';
gutil.log('Using file', gutil.colors.magenta(gulpfile));
require('./' + gulpfile);
