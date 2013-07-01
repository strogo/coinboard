
@Ticker = new Meteor.Collection 'ticker'
@Conversion = new Meteor.Collection 'conversion'



Template.coinboard.ticker = ->
  ticks = Ticker.find({}, { sort: {datetime: -1 }}).fetch()
  _.map ticks, (x) ->
    x.datetime = moment.unix(x.timestamp).from()
    x



Template.coinboard.eurusd = ->
  f = Conversion.findOne {}
  if f
    (parseFloat(f.sell) + parseFloat(f.buy)) / 2




Template.coinboard.transactions = ->
  Session.get 'newTransaction'
  t = _.clone transactionsShown
  _.map t.reverse(), (x) ->
    value: x


