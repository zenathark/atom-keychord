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
    minor_modes:  null
    editor:       null
    editor_view:  null
    major_mode:   null

    constructor: (@editor) ->
      log "mode manager instantiated with #{@editor}"
      @minor_modes = new Set
      @editor_view = atom.views.getView(@editor)

    addMode: (new_mode) ->
      log "added new mode #{new_mode}"
      @minor_modes.add new_mode

    removeMode: (mode) ->
      log "removed mode #{mode}"
      @minor_modes.delete mode

    activateMode: (new_mode) ->
      log "activate mode #{new_mode}"
      new_mode.activateMode @editor
      @addMode new_mode

    deactivateMode: (mode) ->
      log "deactivate mode #{mode}"
      mode.deactivateMode @editor

    switchMode: (mode) ->
      log "switching to mode #{mode}"
      @major_mode?.deactivateMode @editor
      @major_mode = mode
      @major_mode.activateMode @editor

    activate: ->
      log "Activating all modes"
      @minor_modes.forEach (state) => state.activateMode @editor

    deactivate: ->
      log "Deactivating all modes"
      @minor_modes.forEach (state) => state.deactivateMode @editor
