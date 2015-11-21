# mode-manager.coffee --- Contains the mode manager for each editor
# Author: Zenathark
# Mantainer: Zenathark
#
# Version 0.0.1
# Date 2015-11-20
#
# Each editor on wicked-mode has its own mode manager. This file Contains
# the definition of the base mode manager.

name = 'wicked:mode-manager'
log = require('./logger') name

module.exports =
  class ModeManager
    states: null
    editor: null
    editor_view: null

    constructor: (@editor) ->
      log "mode manager instantiated with #{@editor}"
      @states = new Set
      @editor_view = atom.views.getView(@editor)

    add_mode: (new_mode) ->
      log "added new mode #{new_mode}"
      @states.add new_mode

    remove_mode: (mode) ->
      log "removed mode #{mode}"
      @states.delete mode

    activate_mode: (new_mode) ->
      log "activate mode #{new_mode}"
      new_mode.activate_mode @editor
      @add_mode new_mode

    deactivate_mode: (mode) ->
      log "deactivate mode #{mode}"
      mode.deactivate_mode @editor

    switch_mode: (mode) ->
      log "switching to mode #{mode}"
      @deactivate()
      @activate_mode mode

    activate: ->
      log "Activating all modes"
      @states.forEach (state) => state.activate_mode @editor

    deactivate: ->
      log "Deactivating all modes"
      @states.forEach (state) => state.deactivate_mode @editor
