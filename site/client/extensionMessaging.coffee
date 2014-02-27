window.addEventListener "message", ((event) ->
    # We only accept messages from ourselves
    return  unless event.source is window
    if (event.data.type)
        console.log "Got a extension message"
        history = event.data.text
        userTitles = collectTitles(history)
        Session.set "userTitles", userTitles
), false



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