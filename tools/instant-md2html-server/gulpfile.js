const fs = require('fs')
const showdown = require('showdown')

const converter = new showdown.Converter()
const gulp = require('gulp')
const connect = require('gulp-connect')

const args = process.argv.slice(3).map(_ => _.slice(2))
const mdFile = args[0]
const port = args[1]
const theme = args[2]
const htmlFile = __dirname + '/static/index.html'
const templateFile = __dirname + '/static/template.html'
 
//server
gulp.task('connect',function (done) {
	connect.server({
    root: __dirname + '/static/',
		port,
		livereload: true
	})
  done()
})

function reload () {
  const text = fs.readFileSync(mdFile, 'utf-8')
  let html = fs.readFileSync(templateFile).toString()
  html = html.replace('{{html}}', converter.makeHtml(text))
  html = html.replace('{{theme}}', theme)
  fs.writeFileSync(htmlFile, html)

	return gulp.src(htmlFile)
		.pipe(connect.reload())
}

gulp.task('reload', reload)

gulp.task('watch',function (done) {
	gulp.watch(mdFile, gulp.series('reload'))
  reload()
  done()
})

gulp.task('default', gulp.parallel('connect', 'watch'))
