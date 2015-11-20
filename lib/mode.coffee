# state.coffee --- Contains the base class of a *MODE*
# Author: Zenathark
# Mantainer: Zenathark
#
# Version 0.0.1
# Date 2015-11-19
#
# As with vim and emacs, wicked-mode defines *modes* of operation for
# the atom editor. Each mode has its own properies and behavior.
# Also, keybindings must be defined for each mode.

_ = require 'underscore-plus'

module.exports =
  # Base class for modes
  #
  # This is the base class for all modes of wicked-mode. This class is
  # heavily inspired on the evil-define-macro of evil-mode for emacs.
  #
  # Properties:
  #   * `tag` Mode status line indicator
  #   * `message` Echo message when changing to mode
  #   * `cursor` Type of cursor for mode
  #   * `entry_hook` Functions to run when activating mode
  #   * `exit_hook` Functions to run when deactivating mode
  #   * `enable` Modes to enable when mode is enable
  #
  # Methods:
  #   * `activate_mode` Activate this mode
  #   * `deactivate_mode` Deactivate this mode
  #   * `activate` If presents, the method is invoked when activating
  #     mode
  #   * `deactivate` If presents, the method is invoked when
  #     deactivating mode
  #   * `add_entry_hook` Adds a function to the entry hooks
  #   * `add_exit_hook` Adds a function to the exit hooks
  #   * `add_all_entry_hook` Adds a list of functions to the entry hook
  #   * `add_all_exit_hook` Adds a list of functions to the exit hook
  #   * `add_enable` Adds a mode to enable
  #   * `add_all_enable` Adds a list of modes to enable
  #
  #
  # When mode is activate through `activate_mode`, all functions in
  # entry-hook are invoked. Also, each mode listed in `enable` is also
  # activated in order.
  # Because each mode in `enable` is activated before this mode, any
  # changes made by the extra mode in `enable` can be potentially overwrited
  # by this mode.
  # When mode is deactivate through `deactivate_mode`, all functions in
  # exit-hook are invoked and all modes in `enable` are deactivated in
  # order.
  class Mode
    tag:        null
    message:    null
    cursor:     null
    entry_hook: null
    exit_hook:  null
    enable:     null

    constructor: (@tag='', @message='', @cursor='.block') ->
      @entry_hook = new Set
      @exit_hook  = new Set
      @enable     = new Set

    activate_mode: (editor) ->
      @activate(editor) if @activate?
      @entry_hook.forEach (hook) => hook.call(this)
      @enable.forEach (extra) => extra.activate_mode(editor)
      #extra_behavior.call(this) for extra_behavior in @entry_hook
      #extra_mode.activate_mode(editor) for extra_mode in @enable

    deactivate_mode: (editor) ->
      @deactivate(editor) if @deactivate?
      @exit_hook.forEach (hook) => hook.call(this)
      @enable.forEach (extra) => extra.deactivate_mode(editor)
      #extra_behavior.call(this) for extra_behavior in @exit_hook
      #extra_mode.deactivate_mode(editor) for extra_mode in @enable

    add_entry_hook: (f) ->
      @entry_hook.add f

    add_exit_hook: (f) ->
      @exit_hook.add f

    add_all_entry_hook: (fs) ->
      for i in fs
        @add_entry_hook i


    add_all_exit_hook: (fs) ->
      for i in fs
        @add_exit_hook i

    add_enable: (f) ->
      @enable.add f

    add_all_enable: (fs) ->
      for i in fs
        @add_enable i
