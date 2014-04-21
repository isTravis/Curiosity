window.addEventListener "message", ((event) ->
    # We only accept messages from ourselves
    return  unless event.source is window
    if (event.data.type)
        console.log "Got a extension message"
        $('#hasExtension').addClass("hidden")
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
    visitTimes = [] # This is only going to store last visits. On a full release, you'd want to have better tracking of all times visited a site, rather than just last
    _.forEach history, (item) ->
        # console.log item
        try
            title = item.url.split("wiki/")[1].split("#")[0]
            # console.log title
            collectedPages += 1
            titles.push(title)
            visitTimes.push(item.lastVisitTime)
        catch err
            # console.log err
            missedPages += 1
    console.log "Collected : " + collectedPages
    console.log "Missed : " + missedPages
    Session.set "visitTimes", visitTimes
    return titles


Template.hasExtension.events =
    "click #hasExtension": (d) ->
        console.log "just clicked it"
        chrome.webstore.install()
        console.log "and after"