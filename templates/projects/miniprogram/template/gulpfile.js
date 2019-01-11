let gulp = require('gulp')
let less = require('gulp-less')
let del = require('del')
let rename = require('gulp-rename');

let styleExts = ['.wxss', 'less']
let srcPath = 'src/**/*'
let stylePath = styleExts.map(_ => srcPath + _)
let noStylePath = [srcPath, ...stylePath.map(_ => '!' + _)]

gulp.task('watch', function () {
  gulp.watch(stylePath, ['build:style'])
  gulp.watch(noStylePath, ['build:copy'])
})

gulp.task('build:style', function () {
  gulp
    .src('src/**/*.wxss', { base: 'src' })
    .pipe(less())
    .pipe(
      rename(function (path) {
        path.extname = '.wxss'
      })
    )
    .pipe(gulp.dest('dist'))
})

gulp.task('build:copy', function () {
  gulp
    .src(
      noStylePath,
      { base: 'src' }
    )
    .pipe(gulp.dest('dist'))
})

gulp.task('clean', function () {
  del.sync('dist/**', {force: true})
})

gulp.task('default', ['clean', 'watch', 'build:style', 'build:copy'])
