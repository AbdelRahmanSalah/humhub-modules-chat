'use strict';

var gulp = require('gulp'),
  http = require('http'),
  exec = require('child_process').exec,
  gutil = require('gulp-util'),
  debug = require('gulp-debug'),
  clear = require('clear'),
  clean = require('gulp-rimraf'),
  counter = 0;

var cmd = 'elm make ./src/Main.elm --output ./elm-mail.js';
clear();
gulp.task('default', ['watch', 'elm']);

gulp.task('watch', function(cb) {
  gulp.watch('./src/*.elm', ['elm']);
});

gulp.task('elm', ['clean'], function(cb) {
  if (counter > 0){
    clear();
  }
  return exec(cmd, function(err, stdout, stderr) {
      if (err){
        gutil.log(gutil.colors.red('elm make: '),gutil.colors.red(stderr));
      } else {
        gutil.log(gutil.colors.green('elm make: '), gutil.colors.green(stdout));
      }
      cb();
    });
  counter++;
});

gulp.task('clean', () => {
  return gulp.src('./chat.js', { read: false }).pipe(clean())
})
// echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
