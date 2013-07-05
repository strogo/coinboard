
@Ticker = new Meteor.Collection 'ticker'
@Conversion = new Meteor.Collection 'conversion'



Template.coinboard.events
  'click button': (evt) ->
    el = evt.toElement
    Session.set 'currency', el.value

Template.coinboard.currencyIs = (cur) ->
  Session.equals 'currency', cur



getTicks = ->
  # limit: 10 doesn't work, possibly because sort doesn't work
  ticks = Ticker.find({}, { sort: {datetime: -1 }}).fetch()
  if Session.equals 'currency', 'EURUSD'
    rate = getEURUSD()
  else
    rate = 1
  convert = (v) ->
    (v / rate).toFixed(2)
  ticks = _.sortBy ticks, (x) ->
    -x.timestamp
  ticks = ticks.slice 0, 10
  ticks = _.map ticks, (x) ->
    x.datetime = moment.unix(x.timestamp).from()
    x.ask = convert x.ask
    x.bid = convert x.bid
    x.high = convert x.high
    x.last = convert x.last
    x.low = convert x.low
    x

Template.coinboard.ticker = ->
  getTicks()


getEURUSD = ->
  f = Conversion.findOne {}
  if f
    (parseFloat(f.sell) + parseFloat(f.buy)) / 2


Template.coinboard.eurusd = ->
  getEURUSD()



Template.coinboard.transactions = ->
  Session.get 'newTransaction'
  t = _.clone transactionsShown
  transactionsShown.shift() if transactionsShown.length > 25
  _.map t.reverse(), (x) ->
    value: x


@myNewChart = null
@ctx = null
@data = null

@drawChart = ->


Meteor.startup ->
  Session.set 'currency', 'EURUSD'


