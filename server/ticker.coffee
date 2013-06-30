
Ticker = new Meteor.Collection 'ticker'

Conversion = new Meteor.Collection 'conversion'


Meteor.startup ->
  Meteor.setInterval updateData, 10000


updateData = ->
  Meteor.http.get 'https://www.bitstamp.net/api/ticker/', (data) ->
    # why is it null?
    console.log data
    Ticker.insert data

  Meteor.http.get 'https://www.bitstamp.net/api/eur_usd/', (data) ->
    console.log data
    Conversion.insert data

