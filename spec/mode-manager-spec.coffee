ModeManager = require '../lib/mode-manager'
{NORMAL, INSERT, VISUAL} = require '../lib/core-modes'
_ = require 'underscore-plus'

describe 'ModeManager', ->
  editor = null

  beforeEach ->

    waitsForPromise ->
      atom.workspace.open()

    runs ->
      editor = atom.workspace.getActiveTextEditor()

  describe 'when a ModeManager is added to an editor', ->

    it 'should add the mode to te view', ->
      mm = new ModeManager editor
      mm.activateMode NORMAL
      editor_view = atom.views.getView(editor)
      expect('wicked-normal' in editor_view.classList).toBeTruthy()

    it 'should add the mode to the ModeManager list', ->
      mm = new ModeManager editor
      mm.addMode NORMAL
      expect(mm.minor_modes.has(NORMAL)).toBeTruthy()

    it 'should add a mode when change from empty state', ->
      mm = new ModeManager editor
      mm.switchMode NORMAL
      expect(mm.major_mode).toBe NORMAL

    it 'should deactivate old mode and activate a new one', ->
      mm = new ModeManager editor
      mm.switchMode NORMAL
      mm.switchMode INSERT
      expect(mm.major_mode).toBe INSERT

  describe 'when a ModeManager is removed from an editor', ->
    mm = null

    beforeEach ->
      mm = new ModeManager editor
      mm.addMode NORMAL

    it 'should remove the mode from the view', ->
      mm.removeMode NORMAL
      editor_view = atom.views.getView(editor)
      expect('wicked-normal' in editor_view.classList).not.toBeTruthy()

    it 'should remove the mode from the ModeManager', ->
      mm.removeMode NORMAL
      expect(mm.minor_modes.has(NORMAL)).not.toBeTruthy()
