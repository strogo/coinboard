
@Ticker = new Meteor.Collection 'ticker'
@Conversion = new Meteor.Collection 'conversion'

Meteor.startup ->
  Session.set 'currency', 'EURUSD'


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



Meteor.startup ->
  ctx = $("#myChart").get(0).getContext("2d")
  data =
    labels : ["January","February","March","April","May","June","July"],
    datasets : [
      {
        fillColor : "rgba(220,220,220,0.5)",
        strokeColor : "rgba(220,220,220,1)",
        pointColor : "rgba(220,220,220,1)",
        pointStrokeColor : "#fff",
        data : [65,59,90,81,56,55,40]
      },
      {
        fillColor : "rgba(151,187,205,0.5)",
        strokeColor : "rgba(151,187,205,1)",
        pointColor : "rgba(151,187,205,1)",
        pointStrokeColor : "#fff",
        data : [28,48,40,19,96,27,100]
      }
     ]
  data = getTicks()
  myNewChart = new Chart(ctx).PolarArea(data)
