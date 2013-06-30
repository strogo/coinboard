
# Terminate previous connection, if any

# Display the latest transaction so the user sees something.

# New Transaction

# if ((outputs[i].addr) == DONATION_ADDRESS) {
#					bitcoins = data.x.out[i].value / satoshi;
#					new Transaction(bitcoins, true);
#					return;
#				    }

# Filter out the orphaned blocks.

#WebSockets are not supported.

TradeSocket = ->

satoshi = 100000000
DELAY_CAP = 1000

lastBlockHeight = 0

@TransactionSocket = ->

@transactionsShown = []

TransactionSocket.init = ->
  @connection.close()  if @connection
  if "WebSocket" of window
    connection = new ReconnectingWebSocket("ws://ws.blockchain.info:8335/inv")
    @connection = connection
    StatusBox.reconnecting "blockchain"
    connection.onopen = ->
      console.log "Blockchain.info: Connection open!"
      StatusBox.connected "blockchain"
      newTransactions = op: "unconfirmed_sub"
      newBlocks = op: "blocks_sub"
      connection.send JSON.stringify(newTransactions)
      connection.send JSON.stringify(newBlocks)
      connection.send JSON.stringify(op: "ping_tx")

    connection.onclose = ->
      console.log "Blockchain.info: Connection closed"
      if $("#blockchainCheckBox").prop("checked")
        StatusBox.reconnecting "blockchain"
      else
        StatusBox.closed "blockchain"

    connection.onerror = (error) ->
      console.log "Blockchain.info: Connection Error: " + error

    connection.onmessage = (e) ->
      data = JSON.parse(e.data)
      if data.op is "utx"
        transacted = 0
        i = 0

        while i < data.x.out.length
          transacted += data.x.out[i].value
          i++
        bitcoins = transacted / satoshi
        console.log "Transaction: " + bitcoins + " BTC"
        transactionsShown.push bitcoins
        Session.set 'newTransaction', Meteor.uuid()
        donation = false
        outputs = data.x.out
        i = 0

        while i < outputs.length
          i++
        #setTimeout (->
        #  new Transaction(bitcoins)
        #), Math.random() * DELAY_CAP
      else if data.op is "block"
        blockHeight = data.x.height
        transactions = data.x.nTx
        volumeSent = data.x.estimatedBTCSent
        blockSize = data.x.size
        if blockHeight > lastBlockHeight
          lastBlockHeight = blockHeight
          console.log "New Block"
          new Block(blockHeight, transactions, volumeSent, blockSize)
  else
    console.log "No websocket support."
    StatusBox.nosupport "blockchain"

TransactionSocket.close = ->
  @connection.close()  if @connection
  StatusBox.closed "blockchain"

TradeSocket.init = ->

  # Terminate previous connection, if any
  @connection.close()  if @connection
  if "WebSocket" of window
    connection = new ReconnectingWebSocket("ws://websocket.mtgox.com:80/mtgox")
    @connection = connection
    StatusBox.reconnecting "mtgox"
    connection.onopen = ->
      console.log "Mt.Gox: Connection open!"
      StatusBox.connected "mtgox"
      unsubDepth =
        op: "unsubscribe"
        channel: "24e67e0d-1cad-4cc0-9e7a-f8523ef460fe"

      connection.send JSON.stringify(unsubDepth)

    connection.onclose = ->
      console.log "Mt.Gox: Connection closed"
      if $("#mtgoxCheckBox").prop("checked")
        StatusBox.reconnecting "mtgox"
      else
        StatusBox.closed "mtgox"

    connection.onerror = (error) ->
      console.log "Mt.Gox: Connection Error: " + error

    connection.onmessage = (e) ->
      message = JSON.parse(e.data)
      console.log message
      if message.trade
        console.log "Trade: " + message.trade.amount_int / satoshi + " BTC | " + (message.trade.price * message.trade.amount_int / satoshi) + " " + message.trade.price_currency

        # 0.57 BTC | 42.75 USD
        bitcoins = message.trade.amount_int / satoshi
        currency = (message.trade.price * message.trade.amount_int / satoshi)
        currencyName = message.trade.price_currency
        #setTimeout (->
        #  new Transaction(bitcoins, false, currency, currencyName)
        #), Math.random() * DELAY_CAP
  else

    #WebSockets are not supported.
    console.log "No websocket support."
    StatusBox.nosupport "mtgox"

TradeSocket.close = ->
  @connection.close()  if @connection
  StatusBox.closed "mtgox"
