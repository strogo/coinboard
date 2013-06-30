
@Ticker = new Meteor.Collection 'ticker'
@Conversion = new Meteor.Collection 'conversion'



Template.hello.ticker = ->
  Ticker.find {}


Template.hello.eurusd = ->
  #f = Conversion.find {}
  #(f.sell + f.buy) / 2.




Template.hello.transactions = ->
  Session.get 'newTransaction'
  t = _.clone transactionsShown
  _.map t.reverse(), (x) ->
    value: x


