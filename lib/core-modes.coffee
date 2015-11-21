# core-modes.coffee --- Contains the core modes of wicked-mode package
# Author: Zenathark
# Mantainer: Zenathark
#
# Version 0.0.1
# Date 2015-11-19
#
# As with vim and emacs, wicked-mode defines *modes* of operation for
# the atom editor. Each mode has its own properies and behavior.
# On this file, the core modes are defined. Each core mode is based on
# the VIM modes

_ = require 'underscore-plus'
Mode = require './mode.coffee'

mixin =
  activate: -> console.log 'Hello from Normal Mode'

NORMAL = _.extend new Mode('wicked-normal', tag='N'), {activate: -> console.log 'Hello from Normal Mode'}
INSERT = _.extend(new Mode(tag='I'), {activate: -> console.log 'Hello from Insert Mode'})
VISUAL = _.extend(new Mode(tag='V'), {activate: -> console.log 'Hello from Visual Mode'})

module.exports = {NORMAL, INSERT, VISUAL}
  # k: -> 6
  # INSERT = _.extend(new Mode(tag='I'), {activate: -> console.log 'Hello from Insert Mode'})
  # VISUAL = _.extend(new Mode(tag='V'), {activate: -> console.log 'Hello from Visual Mode'})
