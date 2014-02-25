window.addEventListener "message", ((event) ->
    # We only accept messages from ourselves
    return  unless event.source is window
    # if (event.data.type and (event.data.type is "FROM_PAGE_WIKI"))
    #     console.log "gotWikimessage"
    #     # console.log "message gotten"
    #     console.log event.data.text
    #     console.log "number of pages: " + event.data.text.length
    #     Session.set "status", "Parsing Wikipedia History: " + event.data.text.length + " New Pages."
    #     # Meteor.call "inputHistory", event.data.text
    #     Session.set "updated", event.data.text
    #     Session.set "historyValues", event.data.text
        
    #     userID = event.data.userID
    #     if userID == ''
    #       console.log "Got Empty ID"
    #       userID = makeID()
    #       console.log "User ID is now: " + userID
    #     Session.set "userID", userID
    #     # console.log "event.data.text " + event.data.text
    #     Session.set "receivedHistoryTime", new Date().getTime()
    #     # console.log "MessageHistory time " + (Session.get "receivedHistoryTime")
    # else if (event.data.type and (event.data.type is "FROM_PAGE_EDGES"))
    #     # console.log "hereere"
    #     console.log "Gotedgemessage"
    #     Session.set "status", "Parsing Edges History"
    #     # Meteor.call "inputHistory", event.data.text
    #     Session.set "updated", event.data.text
    #     Session.set "edges", event.data.text
    #     Session.set "scrapedIDs", event.data.scrapedIDs
    #     console.log "inmessage ids" + event.data.scrapedIDs
    #     # Session.set "userID", event.data.userID
    #     draw(200)
    #     # console.log event.data.text
    #     # console.log "event.data.text " + event.data.text
    #     Session.set "receivedHistoryTime", new Date().getTime()
    #     # console.log "MessageHistory time " + (Session.get "receivedHistoryTime")
    if (event.data.type)
        console.log "Got a extension message"
        history = event.data.text
        # console.log history
        userTitles = collectTitles(history)
        Session.set "userTitles", userTitles
), false


@makeID = () ->
  text = ""
  possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
  i = 0

  while i < 8
    text += possible.charAt(Math.floor(Math.random() * possible.length))
    i++
  return text


@postToExtension = (serverData, userID,scrapedIDs) ->
    window.postMessage
      type: "FROM_Server"
      text: serverData
      userID: userID
      scrapedIDs: scrapedIDs
    , "*"

@collectTitles = (history) ->
    collectedPages =0
    missedPages = 0
    titles = []
    _.forEach history, (item) ->
        try
            title = item.url.split("wiki/")[1].split("#")[0]
            # console.log title
            collectedPages += 1
            titles.push(title)
        catch err
            # console.log err
            missedPages += 1
    console.log "Collected : " + collectedPages
    console.log "Missed : " + missedPages
    return titles


Template.hasExtension.events =
    "click #hasExtension": (d) ->
        console.log "just clicked it"
        chrome.webstore.install()
        console.log "and after"