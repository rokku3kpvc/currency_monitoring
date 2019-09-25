App.rates = App.cable.subscriptions.create "RatesChannel",
  connected: ->
    console.log('connected to socket')

  disconnected: ->
    console.log('disconnected from socket')

  received: (data) ->
    console.log(data)
