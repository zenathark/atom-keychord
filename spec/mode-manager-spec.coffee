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
      mm.activate_mode NORMAL
      editor_view = atom.views.getView(editor)
      expect('wicked-normal' in editor_view.classList).toBeTruthy()

    it 'should add the mode to the ModeManager list', ->
      mm = new ModeManager editor
      mm.add_mode NORMAL
      expect(mm.states.has(NORMAL)).toBeTruthy()

  describe 'when a ModeManager is removed from an editor', ->

    mm = null

    beforeEach ->
      mm = new ModeManager editor
      mm.add_mode NORMAL

    it 'should remove the mode from the view', ->
      mm.remove_mode NORMAL
      editor_view = atom.views.getView(editor)
      expect('wicked-normal' in editor_view.classList).not.toBeTruthy()

    it 'should remove the mode from the ModeManager', ->
      mm.remove_mode NORMAL
      expect(mm.states.has(NORMAL)).not.toBeTruthy()
