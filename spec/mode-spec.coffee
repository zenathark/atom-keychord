Mode = require '../lib/mode'
_ = require 'underscore-plus'

describe 'Mode', ->
  editor = null

  beforeEach ->

    waitsForPromise ->
      atom.workspace.open()

    runs ->
        editor = atom.workspace.getActiveTextEditor()

  describe 'when mode is instantiated', ->
    it 'using defaults creates an empty mode', ->
      test_mode = new Mode 'test'
      expect(test_mode.selector).toBe 'test'
      expect(test_mode.tag).toBe ''
      expect(test_mode.message).toBe ''
      expect(test_mode.cursor).toBe '.block'
      expect(test_mode.entry_hook).toEqual(new Set)
      expect(test_mode.exit_hook).toEqual(new Set)
      expect(test_mode.enable).toEqual(new Set)

    it 'creates a new mode with parameters', ->
      test_mode = new Mode('test', 'T', 'Test Mode Activated', '.bar')
      expect(test_mode.tag).toBe 'T'
      expect(test_mode.message).toBe 'Test Mode Activated'
      expect(test_mode.cursor).toBe '.bar'
      expect(test_mode.entry_hook).toEqual(new Set)
      expect(test_mode.exit_hook).toEqual(new Set)
      expect(test_mode.enable).toEqual(new Set)


  describe 'when a hook is added', ->
    test_mode = null
    root = jasmine.getGlobal()
    a_global = root.a_global = 0

    beforeEach ->
      test_mode = new Mode('test', 'T', 'Test Mode Activated', '.bar')
      a_global = 0

    it 'as entry hook, the hooks is stored', ->
      hk = -> 1
      test_mode.add_entry_hook hk
      expect(test_mode.entry_hook.has(hk)).toBeTruthy()
      m_hk = []
      m_hk.push -> 1
      m_hk.push -> 2
      test_mode.add_all_entry_hook m_hk
      expect(test_mode.entry_hook.has(m_hk[0])).toBeTruthy()
      expect(test_mode.entry_hook.has(m_hk[1])).toBeTruthy()


    it 'is called when the mode is activated', ->
      hk1 = jasmine.createSpy('first hooked function')
      hk2 = jasmine.createSpy('second hooked function')
      test_mode.add_entry_hook hk1
      test_mode.add_entry_hook hk2
      test_mode.activate_mode editor
      expect(hk1).toHaveBeenCalled()
      expect(hk2).toHaveBeenCalled()

    it 'as exit hooks, the hooks are stored', ->
      hk = -> 1
      test_mode.add_exit_hook hk
      expect(test_mode.exit_hook.has(hk)).toBeTruthy()
      m_hk = []
      m_hk.push -> 1
      m_hk.push -> 2
      test_mode.add_all_exit_hook m_hk
      expect(test_mode.exit_hook.has(m_hk[0])).toBeTruthy()
      expect(test_mode.exit_hook.has(m_hk[1])).toBeTruthy()


    it 'is called when the mode is deactivated', ->
      hk1 = jasmine.createSpy('first hooked function')
      hk2 = jasmine.createSpy('second hooked function')
      test_mode.add_exit_hook hk1
      test_mode.add_exit_hook hk2
      test_mode.deactivate_mode editor
      expect(hk1).toHaveBeenCalled()
      expect(hk2).toHaveBeenCalled()

    it 'can manipulate gobal variables', ->
      test_mode.add_entry_hook -> jasmine.getGlobal().a_global = 3
      test_mode.activate_mode editor
      expect(jasmine.getGlobal().a_global).toBe 3
      test_mode.add_exit_hook -> jasmine.getGlobal().a_global = 5
      test_mode.deactivate_mode editor
      expect(jasmine.getGlobal().a_global).toBe 5

    it 'can manipulate instance variables', ->
      test_mode.an_instance_variable = 0
      test_mode.add_entry_hook -> this.an_instance_variable = 3
      test_mode.activate_mode editor
      expect(test_mode.an_instance_variable).toBe 3
      test_mode.add_exit_hook -> @an_instance_variable = 5
      test_mode.deactivate_mode editor
      expect(test_mode.an_instance_variable).toBe 5

  describe 'when a new mode is created', ->
    test_mode = null

    beforeEach ->
      test_mode = new Mode('test', 'T', 'Test Mode Activated', '.bar')

    it 'invokes the activate method on activation mode', ->
      f = jasmine.createSpy('activation method')
      mixin =
        activate: f
      _.extend test_mode, mixin
      test_mode.activate_mode editor
      expect(f).toHaveBeenCalled()

    it 'invokes the deactivate method on deactivation mode', ->
      f = jasmine.createSpy('deactivation method')
      mixin =
        deactivate: f
      _.extend test_mode, mixin
      test_mode.deactivate_mode editor
      expect(f).toHaveBeenCalled()

    describe 'and a secondary mode is created', ->
      slave_mode = null

      beforeEach ->
        slave_mode = new Mode('slave', 'S', 'Slave Mode Activated', '.block')

      it 'is included in enable modes', ->
        test_mode.add_enable slave_mode
        expect(test_mode.enable.has(slave_mode)).toBeTruthy()

      it 'invokes the activate method on activation mode', ->
        f = jasmine.createSpy('activation_mode method')
        slave_mode.activate_mode = f
        test_mode.add_enable slave_mode
        test_mode.activate_mode editor
        expect(f).toHaveBeenCalled()

      it 'invokes the deactivate method on deactivation mode', ->
        f = jasmine.createSpy('activation_mode method')
        slave_mode.deactivate_mode = f
        test_mode.add_enable slave_mode
        test_mode.deactivate_mode editor
        expect(f).toHaveBeenCalled()
