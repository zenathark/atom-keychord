# mode-manager.coffee --- Contains the mode manager for each editor
# Author: Zenathark
# Mantainer: Zenathark
#
# Version 0.0.1
# Date 2015-11-20
#
# Each editor on wicked-mode has its own mode manager. This file Contains
# the definition of the base mode manager.

module.export =
  class ModeManager
    states: null
    editor: null

  constructor: (@editor) ->
    @states = new Set

  add_mode: (new_mode) ->
    @states.add new_mode

  remove_mode: (mode) ->
    @states.delete mode

  activate_mode: (new_mode) ->
    new_mode.activate_mode()
    @add_mode new_mode

  deactivate_mode: (mode) ->
    mode.deactivate_mode()

  activate: ->
    @states.forEach (state) -> state.activate_mode()

  deactivate: ->
    @states.forEach (state) -> state.deactivate_mode()
