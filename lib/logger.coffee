debug = require 'debug'
debuggers = ['wicked:mode', 'wicked:mode-manager', 'wicked:core-modes']

debug.enable 'wicked:mode'
debug.enable 'wicked:mode-manager'
debug.enable 'wicked:core-modes'

loggers = new Map

debuggers.forEach (group) ->
  logger = debug group
  logger = console.log.bind console
  loggers.set group, logger

get = (name) ->
  loggers.get(name)

module.exports = get
