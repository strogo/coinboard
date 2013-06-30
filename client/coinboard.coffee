
Template.hello.transactions = ->
  Session.get 'newTransaction'
  _.map transactionsShown, (x) ->
    value: x