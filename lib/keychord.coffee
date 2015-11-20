{CompositeDisposable} = require 'atom'

module.exports = Keychord =
  keychordView: null
  modalPanel: null
  subscriptions: null
  active: false
  oldKeyMap: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a
    # CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace',
                                         'keychord:toggle': => @toggle()
    window.addEventListener('core:move-up',
                            (event) => console.log('up', event))



  deactivate: ->
    @subscriptions.dispose()

  #serialize: ->
  #  keychordViewState: @keychordView.serialize()

  toggle: ->
    console.log 'Keychord captured keymaps!'
    console.log atom.keymaps
