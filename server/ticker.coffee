
Ticker = new Meteor.Collection 'ticker'

Conversion = new Meteor.Collection 'conversion'


Meteor.startup ->
  updateData()
  Meteor.setInterval updateData, 10 * 60 * 1000


updateData = ->
  Meteor.http.get 'https://www.bitstamp.net/api/ticker/', (err, data) ->
    d = data.data
    d.high = parseFloat d.high
    d.last = parseFloat d.last
    d.bid = parseFloat d.bid
    d.low = parseFloat d.low
    d.ask = parseFloat d.ask
    d.timestamp = parseInt d.timestamp
    d.volume = parseFloat d.volume
    console.log d
    Ticker.insert d

  Meteor.http.get 'https://www.bitstamp.net/api/eur_usd/', (err, data) ->
    # console.log data
    Conversion.insert data.data

