Template.wikiData.created = ->
	Session.set "receivedHistoryTime", 0
	Session.set "renderNetwork", {}
	Session.set "status", "Reading Wikipedia History"

Template.status.status = ->
	Session.get "status"


Template.wikiData.wikiData = ->
	userID = Session.get "userID"
	console.log "In Template, got user ID of " + userID

	xx = WikiData.findOne({accountID:userID})
	if xx
		if xx['receivedHistoryTime'] == (Session.get "receivedHistoryTime")
			if xx['edges']

				scrapedIDs = xx['scrapedIDs']
				Session.set "scrapedIDs", scrapedIDs
				Session.set "status", "okkk"
				startTime = new Date().getTime()
				Session.set "edges", xx['edges']
				draw(200)

				endTime = new Date().getTime()
				totalNewTime = (endTime-startTime)/1000
				console.log "Client Side" + " | " + totalNewTime 
				postToExtension(xx['edges'], userID, scrapedIDs)

	return WikiData.findOne({accountID:userID})


Template.settings.events = 
	"mouseenter .fa-cog": (d) ->
		srcE = if d.srcElement then d.srcElement else d.target
		console.log srcE.parentNode
		# srcE = srcE.parentNode
		$(srcE.parentNode).children(".controls").removeClass("hidden")


    
	"mouseleave div.controls": (d) ->
		srcE = if d.srcElement then d.srcElement else d.target
		console.log srcE.parentNode
		console.log srcE
		# srcE = srcE.parentNode
		$(".controls").addClass("hidden")


	# "click .install": (d) ->
	# 	chrome.webstore.install()

	"change .node-slider": (d) ->
		nodeVal = $(".nodeRange").attr("value")
		draw(nodeVal)

	"click .submit": (d)->
		# console.log "wat"
		srcE = if d.srcElement then d.srcElement else d.target
		nodeVal = $(".nodeRange").attr("value")
		strengthVal = $(".strengthRange").attr("value")
		console.log nodeVal
		# userID = Session.get "userID"
		draw(nodeVal)
		# nodeVal = $(".nodeRange").attr("value") 

@draw = (numNodes) ->
	localEdges = Session.get "edges"
	localIDs = Session.get "scrapedIDs"
	userID = Session.get "userID"
	# console.log ("thisuserID " + userID)
	# xx = WikiData.findOne({accountID:userID})
	# console.log ("thisxx " + xx)
	# console.log xx
	# console.log localHistory
	yy = buildGraph(localEdges,numNodes)

	# renderD3(yy,localIDs)

	clusters = communityDetection(yy)

	# # clusterData = generateClusters(yy)
	renderD4(clusters,localIDs)


