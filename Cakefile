fs            = require 'fs'
{print}       = require 'util'
{spawn, exec} = require 'child_process'

buildBrowserFile = (callback) ->
  options = ['browser.tests.js', '-o', 'test/browser/browserify.js']
  browserify = spawn 'browserify', options
  browserify.stdout.on 'data', (data) -> print data.toString()
  browserify.stderr.on 'data', (data) -> print data.toString()
  browserify.on 'exit', (status) -> callback?() if status is 0

fileserver = (callback) ->
  server = spawn 'node', ["server.js"]
  server.stdout.on 'data', (data) -> print data.toString()
  server.stderr.on 'data', (data) -> print data.toString()
  server.on 'exit', (status) -> callback?() if status is 0

build = (watch, callback) ->
  if typeof watch is 'function'
    callback = watch
    watch = false
  options = ['-c', '-o', 'lib', 'src']
  options.unshift '-w' if watch

  coffee = spawn 'coffee', options
  coffee.stdout.on 'data', (data) -> print data.toString()
  coffee.stderr.on 'data', (data) -> print data.toString()
  coffee.on 'exit', (status) -> callback?() if status is 0

task 'docs', 'Generate annotated source code with Docco', ->
  fs.readdir 'src', (err, contents) ->
    files = ("src/#{file}" for file in contents when /\.coffee$/.test file)
    docco = spawn 'docco', files
    docco.stdout.on 'data', (data) -> print data.toString()
    docco.stderr.on 'data', (data) -> print data.toString()
    docco.on 'exit', (status) -> callback?() if status is 0

task 'build', 'Compile CoffeeScript source files', ->
  build()
    
task 'watch', 'Recompile CoffeeScript source files when modified', ->
  build true

task 'test', 'Run the test suite', ->
  build ->
    require.paths.unshift __dirname + "/lib"
    {reporters} = require 'nodeunit'
    process.chdir __dirname
    reporters.default.run ['test']

task 'browser-tests', 'Build and serve test files for browser', ->
  buildBrowserFile ->
    fileserver()