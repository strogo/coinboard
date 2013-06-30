CONNECTED = "Connected."
CONNECTING = "Connecting..."
NO_SUPPORT = "No browser support."
CLOSED = "Click to connect."


@StatusBox = ->

StatusBox.init = (debugmode) ->
  @blockchain = $("#blockchainStatus")
  @mtgox = $("#mtgoxStatus")
  if debugmode
    @blockchain.html ""
    @mtgox.html "Debug mode."
  if $("#blockchainCheckBox").prop("checked")
    StatusBox.reconnecting "blockchain"
  else
    StatusBox.closed "blockchain"
  if $("#mtgoxCheckBox").prop("checked")
    StatusBox.reconnecting "mtgox"
  else
    StatusBox.closed "mtgox"


# "type" can be either "blockchain" or "mtgox"
StatusBox.connected = (type) ->
  type is "blockchain"

  #this.blockchain.html('Blockchain.info Transactions: <span style="color: green;">' + CONNECTED + '</span>');
  @mtgox.html "Mt.Gox Trades: <span style=\"color: green;\">" + CONNECTED + "</span>"  if type is "mtgox"

StatusBox.reconnecting = (type) ->
  type is "blockchain"

  # this.blockchain.html('Blockchain.info Transactions: <span style="color: yellow;">' + CONNECTING + '</span>');
  @mtgox.html "Mt.Gox Trades: <span style=\"color: yellow;\">" + CONNECTING + "</span>"  if type is "mtgox"

StatusBox.nosupport = (type) ->
  @blockchain.html "Blockchain.info Transactions: <span style=\"color: red;\">" + NO_SUPPORT + "</span>"  if type is "blockchain"
  @mtgox.html "Mt.Gox Trades: <span style=\"color: red;\">" + NO_SUPPORT + "</span>"  if type is "mtgox"

StatusBox.closed = (type) ->
  @blockchain.html "Blockchain.info Transactions: <span style=\"color: gray;\">" + CLOSED + "</span>"  if type is "blockchain"
  @mtgox.html "Mt.Gox Trades: <span style=\"color: gray;\">" + CLOSED + "</span>"  if type is "mtgox"
