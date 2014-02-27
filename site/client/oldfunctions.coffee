# Build Network - and functions for building the network
#################################################

# @buildNetwork = (visitHistory, visitedTitles) ->
# @buildNetwork = (scrapedHistory) ->
# 	console.log "Building Network..."
# 	# Need to build out. This will be the renderable network
# 	# will include links as well as time stamps and the such
# 	# visitHistory.push({url:e.url.split("#")[0], title:thisTitle, visitTime:e.lastVisitTime, visitCount:e.visitCount})
# 	numInMin = .02
# 	sharedMin = 1

# 	firstHopNetwork = {}
# 	count = 0
# 	statuscount = 0
# 	pageListLength = Object.keys(scrapedHistory).length
# 	# console.log "scrape length" + Object.keys(scrapedHistory).length
# 	# console.log pageListLength
# 	numInTitles = {}
# 	totalOriginalTime=0;
# 	totalNewTime = 0;
# 	Session.set "status", "Building Network Nodes: Page "
# 	# Get and built numIn counts
# 	for visit of scrapedHistory
# 		# console.log visit
# 		# div = document.getElementById('here');
# 		# div.innerHTML = div.innerHTML + statuscount;
# 		console.log "Building Network Nodes: Page " + (statuscount+1) + " of " + pageListLength
# 		Session.set "status", "Building Network Nodes: Page " + statuscount+1 + " of " + pageListLength
# 		pageID = visit
# 		if pageID != '-1'
# 			numIn = numInLink(pageID, scrapedHistory)
# 			numInNormal = numIn/scrapedHistory[pageID].length
# 			# console.log getPageTitle(pageID)
# 			# console.log numInNormal
# 			if numInNormal > numInMin
# 				numInTitles[pageID] = numIn
# 		statuscount += 1

# 	console.log "Done with numin"
# 	# console.log "numintitles " + Object.keys(numInTitles).length
# 	# Get and build connections		
# 	statuscount = 0

# 	for page of numInTitles
# 		Session.set "status", "Building Network Links: Page " + statuscount+1 + " of " + pageListLength
# 		# console.log "OMG THIS IS AWESOME!!!!!"
# 		pageID = page
# 		pageTitle = getPageTitle(pageID) 
# 		numIn = numInTitles[pageID]
# 		# console.log 'PageTitle ' + pageTitle + ' | pageID ' + pageID + ' | numIn ' + numIn

# 		index = count
# 		connections = {}

# 		# startTime = new Date().getTime()
# 		for destPage of numInTitles
# 			if parseInt(destPage) != parseInt(pageID)
# 				sharedLinks= sharedLinkCount(scrapedHistory[pageID], scrapedHistory[destPage])
# 				if sharedLinks > sharedMin
# 					connections[destPage] = sharedLinks
# 		# endTime = new Date().getTime()
# 		# totalNewTime += (endTime-startTime)/1000



# 		if Object.keys(connections).length > 0
			
# 			# firstHopNetwork[pageID] = [index,pageTitle,numIn,connections]
# 			firstHopNetwork[pageID] = [index,pageID,pageTitle,numIn,connections]
# 			count += 1

# 		statuscount += 1

# 	console.log firstHopNetwork
# 	for i of firstHopNetwork
# 		# console.log firstHopNetwork[i]
# 		console.log firstHopNetwork[i][2] + " | " + firstHopNetwork[i][3] + " | " + Object.keys(firstHopNetwork[i][4]).length


# 	# console.log firstHopNetwork
# 	# console.log "New: " + totalNewTime + " seconds"
# 	console.log "Done With Network..."
# 	# console.log Object.keys(firstHopNetwork).length
# 	return firstHopNetwork



# @sharedLinkCount = (linkList1, linkList2) ->
#   linkList1.sort()
#   linkList2.sort()
#   ai = bi = 0
#   result = []
#   while ai < linkList1.length and bi < linkList2.length
#     # console.log a[ai]
#     # console.log b[bi]
#     if linkList1[ai] < linkList2[bi]
#       ai++
#     else if linkList1[ai] > linkList2[bi]
#       bi++
#     # they're equal 
#     else
#       result.push ai
#       ai++
#       bi++
#   return result.length


	

# @numInLink = (pageID,scrapedHistory) ->
# 	# console.log "HereNumInLInk"
# 	pageTitle = getPageTitle(pageID)
# 	inLinks = 0
# 	for i of scrapedHistory
# 		histID = i
# 		histLinks = scrapedHistory[i]
# 		try
# 			# console.log page
# 			# console.log Links.findOne({pageID:getPageID(page)})
# 			if histLinks.indexOf(pageTitle) > -1
# 				inLinks += 1
# 		catch err
# 			console.log histID
# 			# console.log Links.findOne({pageID:getPageID(page)})
# 			# console.log err
# 	return inLinks


# @getPageTitle = (pageID) ->
# 	# console.log "here"
# 	# console.log "here" + Session.get "scrapedIDs"
# 	IDs = Session.get "scrapedIDs"
# 	thisTitle = IDs[pageID]
# 	if thisTitle # If we have the pageID already, return that.
# 		return thisTitle
# 	else
# 		return 'noPageFound'




# @createJSON = (network) ->
# 	nodes = []
# 	links = []
# 	# count = 0
# 	# missedConnections = 0

# 	networkLength = Object.keys(network).length
# 	# wtfcounter = 0
# 	Session.set "status", "Formatting Network"
# 	if networkLength
# 		for i in [0..networkLength-1]
# 			# console.log i
# 			page = {}
# 			for thispage of network
# 				if network[thispage][0] == i
# 					page = thispage
# 			# if wtfcounter > 5000
# 			# 	break
# 			# console.log "Formatting Data: Page " + count+1 + " of " + networkLength
# 			# console.log page
# 			# console.log "network[page] " + network[page]
# 			index = network[page][0]
# 			title = network[page][2]
# 			inLinks = network[page][3]
# 			nodes.push({"name":title,"inlinks":inLinks})
# 			for connection of network[page][4]
# 				connectionTitle = connection

# 				# print "Connection title: " + connectionTitle
# 				# try
# 					# console.log "in the try"
# 					# console.log connectionTitle
# 					# console.log connection
# 				connectionIndex = network[connectionTitle][0]
# 				# console.log "index " +connectionIndex
# 				# console.log "linkstrength" + network[page][4][connection]
# 				if connectionIndex != index
# 					connectionStrength = network[page][4][connection]
# 					links.push({"source":index,"target":connectionIndex,"value":connectionStrength})
# 				# catch err
# 				# 	console.log "inthemissed"
# 				# 	missedConnections +=1
# 			# count += 1
# 			# wtfcounter += 1
# 			# console.log  "Missed Connections: " + missedConnections

# 		outputJSON = {"nodes":nodes,"links":links}
# 	# console.log outputJSON
# 	return outputJSON


# @makeID = () ->
#   text = ""
#   possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#   i = 0

#   while i < 8
#     text += possible.charAt(Math.floor(Math.random() * possible.length))
#     i++
#   return text