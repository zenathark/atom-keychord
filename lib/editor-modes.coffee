# mode-manager.coffee --- Contains the mode manager for each editor
# Author: Zenathark
# Mantainer: Zenathark
#
# Version 0.0.1
# Date 2015-11-20
#
# Each editor on wicked-mode has its own mode manager. This file contains
# the definition of the default modes for each editor type.

ModeManager = require './mode-manager'
{NORMAL, INSERT, VISUAL} = require '/.core-modes'

module.exports =
  get_default_editor_manager: (editor) ->
    manager = new ModeManager(editor)
    manager.add_mode NORMAL
