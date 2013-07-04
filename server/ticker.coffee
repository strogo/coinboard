
Ticker = new Meteor.Collection 'ticker'

Conversion = new Meteor.Collection 'conversion'


Meteor.startup ->
  updateData()
  Meteor.setInterval updateData, 10 * 60 * 1000


updateData = ->
  Meteor.http.get 'https://www.bitstamp.net/api/ticker/', (err, data) ->
    # why is it null?
    console.log data
    Ticker.insert data.data

  Meteor.http.get 'https://www.bitstamp.net/api/eur_usd/', (err, data) ->
    console.log data
    Conversion.insert data.data

