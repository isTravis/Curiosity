# Meteor.publish "wikiDataPub", (historyValues, receivedHistoryTime, userID) ->
#     console.log "just Updated"
#     # console.log "updated " + updated
#     # if updated 
#     console.log "Beginning new"
#     console.log "About to Begin everything with userID " + userID
#     if historyValues
# 	    console.log "historyValues be" + historyValues
# 	    beginEverything(historyValues, receivedHistoryTime, userID)
# 	    # beginEverythingGrid(historyValues, receivedHistoryTime, userID)

#     console.log "finished updated"
#     return WikiData.find()

Meteor.publish "userGridDataPub", (userTitles) ->
	# console.log userTitles
	if userTitles isnt null
		console.log userTitles.length + " titles submitted"

		results = TopMillion.find( { articleTitle: { $in: userTitles } } )
		console.log results.fetch().length + " titles found"
		return results

Meteor.publish "userLinksPub", (clickedItem) ->
	# MUST MUST add the userTitles value to the wikilinks db.
	return WikiLinks.find( { pageID: clickedItem })
	# return 0

Meteor.publish "firstHopPub", (userTitles) ->
	if userTitles isnt null
		allLinksObjects = WikiLinks.find({ articleTitle: { $in: userTitles } } ).fetch()
		allFirstHops = []
		# console.log allLinksObjects.count()
		for object of allLinksObjects
			# console.log 
			allFirstHops = allFirstHops.concat(allLinksObjects[object]["links"])
		
		getDistinctArray = (arr) ->
		  dups = {}
		  arr.filter (el) ->
		    hash = el.valueOf()
		    isDup = dups[hash]
		    dups[hash] = true
		    not isDup

		console.log allFirstHops.length
		console.log getDistinctArray(allFirstHops).length
		allResults = TopMillion.find( { pageID: { $in: getDistinctArray(allFirstHops) } } ).fetch()

		sub = this
		collectionName = "firsthops"
		_.forEach allResults, (e) ->
			sub.added collectionName, e._id, e 
		sub.ready()
		return
		# var temp = {};
		# for (var i = 0; i < array.length; i++)
		# temp[array[i]] = true;
		# var r = [];
		# for (var k in temp)
		# r.push(k);
		# return r;

	return 0

Meteor.publish "clickedItemPub", (clickedItem) ->
	if clickedItem != "" and clickedItem != null
		sub = this
		collectionName = "clickeditem"
		xx = TopMillion.find({pageID:clickedItem}).fetch()[0]
		# console.log xx
		sub.added collectionName, xx._id, xx
		sub.ready()
		return
	
	


# Meteor.publish "userDataPub", (historyValues, receivedHistoryTime, userID) ->
#     console.log "just Updated"
#     # console.log "updated " + updated
#     # if updated 
#     console.log "Beginning new"
#     console.log "About to Begin everything with userID " + userID
#     if historyValues
# 	    console.log "historyValues be" + historyValues
# 	    # beginEverything(historyValues, receivedHistoryTime, userID)
# 	    beginEverythingGrid(historyValues, receivedHistoryTime, userID)

#     console.log "finished updated"
#     return UserData.find()


	

# Meteor.publish "topMillionPub", (zoom, myx,myy) ->
# 	console.log "yea Im calling"
# 	if zoom == 1000000

# 		console.log myx
# 		console.log myy
# 		radius = 10
# 		results = TopMillion.find({x: {$gt:myx-radius, $lt:myx+radius}, y: {$gt:myy-radius, $lt:myy+radius}  })
# 		console.log "----"
# 		return results
# 	else
# 		this.stop()




# @beginEverythingGrid = (historyValues, receivedHistoryTime, userID) ->
# 	console.log "well son of a gun"
# 	visitHistory = []
# 	visitedTitles = []

# 	haveEverything = 1

# 	# Want to iterate through all titles and check if they are in the zoom we're currently in.
# 	# make array of those objects, return them, (by storing in UserData)
# 	#client side add a new canvas over it and render the colours.

# 	if haveEverything
# 		startTime = new Date().getTime()
# 		console.log "Starting Title Building"
# 		# For each history item in value
# 		# countyy = 0
# 		pageHistory = {}
# 		visitedIDs = []
# 		scrapedIDs = {}
# 		startTime = new Date().getTime()	
#		 _.forEach historyValues, (e) ->
#		 	# console.log countyy
#		 	# console.log e
#		 	# countyy++
#		 	title = e.title.split(" - Wiki")[0]
#		 	url = e.url.split("://")[1].split("#")[0]
#		 	visitCount = e.visitCount
#		 	visitTime = e.lastVisitTime
#		 	if testURL(e.url) #
# 				# console.log 
# 				pageObject = PageIDs.findOne({url:url})

# 				if pageObject
# 					# console.log pageObject
# 					pageID = pageObject['pageID']
# 					#great we have everything, no scraping or anything, just compile from the known and go
# 					if title == ''
# 						title = pageObject['title']

# 					pageHistory[pageID] = {url:url, title:title, visitTime:visitTime, visitCount:visitCount}
# 					visitedIDs.push(pageID)
# 					scrapedIDs[pageID] = title

# 				else
# 					console.log "No Page: " + url
# 					# Could just be a redirect, check by title instead, maybe? e.title
# 					# add it to the queue of things we need to scrape - but don't do it now.

# 		gridHistory = []

# 		selectedIDs = []
# 		# _.forEach visitedIDs, (id1) ->

# 		gridObject = TopMillion.find({pageID: {$in: visitedIDs}})
# 		gridHistory = gridObject.fetch()
# 			# console.log gridObject
# 			# if gridObject
# 			# 	gridHistory.push(gridObject)

# 		# console.log gridHistory

# 		if gridHistory.length > 0
# 			if userID != null
# 				console.log "got a gridhistory"
# 				# console.log pageHistory
# 				if UserData.findOne({accountID:userID})
# 					UserData.update(
# 						accountID: userID
# 					,
# 						$set:
# 							gridHistory: gridHistory
# 							# receivedHistoryTime: receivedHistoryTime
# 							pageHistory: pageHistory
# 							# edges: myEdges
# 							# scrapedIDs: scrapedIDs
# 					)
# 				else
# 					# Generate a random hash use that as ID
# 					# make sure to send it back to extension and have it stored
# 					# will have to pass it in here to this function above for future iterations
# 					UserData.insert(
# 						accountID: userID
# 						gridHistory: gridHistory
# 						pageHistory: pageHistory
# 						# edges: myEdges
# 						# scrapedIDs: scrapedIDs
# 					)

# 	else 
# 		dontHaveThings(historyValues, receivedHistoryTime, userID)



# @beginEverything = (historyValues, receivedHistoryTime, userID) ->

# 	visitHistory = []
# 	visitedTitles = []
# 	# userID = 'travis'

# 	# if WikiData.findOne({accountID:userID})
# 	# 	haveEverything = 1
# 	# else
# 	haveEverything = 0

# 	# console.log userID
# 	# console.log "wikidataaaaa " + WikiData.findOne({accountID:userID})
	

# 	if haveEverything
# 		startTime = new Date().getTime()
# 		console.log "Starting Title Building"
# 		# For each history item in value
# 		# countyy = 0
# 		pageHistory = {}
# 		visitedIDs = []
# 		scrapedIDs = {}
# 		startTime = new Date().getTime()	
# 		_.forEach historyValues, (e) ->
# 			# console.log countyy
# 			# console.log e
# 			# countyy++
# 			title = e.title.split(" - Wiki")[0]
# 			url = e.url.split("://")[1].split("#")[0]
# 			visitCount = e.visitCount
# 			visitTime = e.lastVisitTime
# 			if testURL(e.url) #
# 				# console.log 
# 				pageObject = PageIDs.findOne({url:url})

# 				if pageObject
# 					# console.log pageObject
# 					pageID = pageObject['pageID']
# 					#great we have everything, no scraping or anything, just compile from the known and go
# 					if title == ''
# 						title = pageObject['title']

# 					pageHistory[pageID] = {url:url, title:title, visitTime:visitTime, visitCount:visitCount}
# 					visitedIDs.push(pageID)
# 					scrapedIDs[pageID] = title

# 				else
# 					console.log "No Page: " + url
# 					# Could just be a redirect, check by title instead, maybe? e.title
# 					# add it to the queue of things we need to scrape - but don't do it now.

# 		myEdges = []
# 		minStrength = 10
# 		_.forEach visitedIDs, (id1) ->
# 			src_edges = Edges.findOne({src:id1}) 
# 			_.forEach visitedIDs, (id2) ->
# 				strengthVal = src_edges[id2]
# 				if strengthVal > minStrength
# 					myEdges.push({src:id1, dest:id2, strength:strengthVal})


# 		endTime = new Date().getTime()
# 		totalNewTime = (endTime-startTime)/1000
# 		console.log "Finished Total Building" + " | " + totalNewTime

# 		console.log "About to add to mongo with ID: " + userID

# 		if _.isEmpty(pageHistory) == false
# 			if userID != null
# 				console.log "got a pagehistory"
# 				# console.log pageHistory
# 				if WikiData.findOne({accountID:userID})
# 					WikiData.update(
# 						accountID: userID
# 					,
# 						$set:
# 							receivedHistoryTime: receivedHistoryTime
# 							pageHistory: pageHistory
# 							edges: myEdges
# 							scrapedIDs: scrapedIDs
# 					)
# 				else
# 					# Generate a random hash use that as ID
# 					# make sure to send it back to extension and have it stored
# 					# will have to pass it in here to this function above for future iterations
# 					WikiData.insert(
# 						accountID: userID
# 						receivedHistoryTime: receivedHistoryTime
# 						pageHistory: pageHistory
# 						edges: myEdges
# 						scrapedIDs: scrapedIDs
# 					)
# 	else 
# 		dontHaveThings(historyValues, receivedHistoryTime, userID)		





# @makeID = () ->
#   text = ""
#   possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
#   i = 0

#   while i < 8
#     text += possible.charAt(Math.floor(Math.random() * possible.length))
#     i++
#   return text




# @goGetTitle = (url) ->
# 	# Use when the history search result returns a title of ''
# 	urlTitle = url.split("wiki/")[1].split("#")[0]
# 	apiURL = 'http://en.wikipedia.org/w/api.php?format=json&action=query&titles=' + urlTitle + '&redirects&prop=revisions'
# 	result = Meteor.http.get(apiURL)
# 	# console.log result
# 	for page of result.data['query']['pages']
# 		pageID = page
# 		# console.log pageID
# 	if pageID != '-1'
# 		# And now add to collection
# 		title = result.data['query']['pages'][pageID]['title']
# 		return title
# 	else
# 		return ''


# @testURL = (url) ->
# 	# Test to make sure the url is what we're looking for. Checks a number of different aspects

# 	isWiki = /wikipedia.org\/wiki\//g # Gets rid of api calls and such
# 	if isWiki.test(url)
# 		# url = 'http://en.wikipedia.org/wiki/Samsung_Galaxy_Tab#Cat'
# 		urlHead = url.split("://")[1].split("wiki/")[0]
# 		# urlHead = url.split("wiki/")[0]
		
# 		if urlHead != 'en.wikipedia.org/' and urlHead !='en.m.wikipedia.org/'
# 			return false;
# 		# console.log( urlHead == 'en.wikipedia.org/' )

# 		# url = 'http://en.wikipedia.org/w/api.php?format=json&action=query&titles=Saudia_Arabia&prop=revisions&rvprop=content'
# 		parsedURL = url.split("wiki/")[1].split("#")[0] # Takes the string after /wiki/ (and before # if it exists)
# 		isFile = /File:/g
# 		isCategory = /Category:/g
# 		isTemplate = /Template:/g
# 		isTemplateTalk = /Template talk:/g
# 		isHelp = /Help:/g
# 		isWikipedia = /Wikipedia:/g
# 		isPortal = /Portal:/g
# 		isUser = /User:/g
# 		isAPI = /api.php/g
# 		isTalk = /Talk:/g
# 		isSpecial = /Special:/g
		
# 		if(isSpecial.test(parsedURL) or isTalk.test(parsedURL) or isAPI.test(parsedURL) or isFile.test(parsedURL) or isCategory.test(parsedURL) or isTemplate.test(parsedURL) or isHelp.test(parsedURL) or isWikipedia.test(parsedURL) or isPortal.test(parsedURL) or isTemplateTalk.test(parsedURL) or isUser.test(parsedURL))
# 			return false
# 		return true
# 	else
# 		return false


# linkSet = []

# @scrapeLinks = (pageID,url) ->
# 	result = Meteor.http.get(url)
	
# 	if result.data.hasOwnProperty('query-continue')
# 		# console.log result.data['query-continue']['links']['gplcontinue']
# 		continueURL ='http://en.wikipedia.org/w/api.php?format=json&action=query&pageids=' + pageID + '&redirects&generator=links&gpllimit=max&gplcontinue='+result.data['query-continue']['links']['gplcontinue']
# 		# console.log "Continuing with " + continueURL

# 		linkSet.concat(scrapeLinks(pageID, continueURL))

# 	for link of result.data['query']['pages']

# 		if link > 0 # Bad pages get thrown as -1
# 			isFile = /File:/g
# 			isCategory = /Category:/g
# 			isTemplate = /Template:/g
# 			isTemplateTalk = /Template talk:/g
# 			isHelp = /Help:/g
# 			isWikipedia = /Wikipedia:/g
# 			isPortal = /Portal:/g
# 			isUser = /User:/g
# 			isAPI = /api.php/g
# 			isTalk = /Talk:/g
# 			isSpecial = /Special:/g
# 			pageTitle = result.data['query']['pages'][link]['title']
# 			if(!isSpecial.test(pageTitle) and !isFile.test(pageTitle) and !isCategory.test(pageTitle) and !isTemplate.test(pageTitle) and !isHelp.test(pageTitle) and !isWikipedia.test(pageTitle) and !isPortal.test(pageTitle) and !isTemplateTalk.test(pageTitle) and !isUser.test(pageTitle) and !isAPI.test(pageTitle) and !isTalk.test(pageTitle))
# 				linkSet.push(pageTitle)
	
# 	return linkSet


# @getPageID = (pageTitle) ->
# 	if PageIDs.findOne({title: pageTitle}) # If we have the pageID already, return that.
# 		return PageIDs.findOne({title: pageTitle}).pageID
# 	else
# 		urltitle = pageTitle.replace(/\ /g, "_")
# 		# Get page id, and use that
# 		url ='http://en.wikipedia.org/w/api.php?format=json&action=query&titles=' + urltitle + '&redirects'
# 		result = Meteor.http.get(url)
# 		for page of result.data['query']['pages']
# 			pageID = page
# 			# console.log pageID
# 			if pageID != '-1'
# 				# And now add to collection
# 				PageIDs.insert(
# 			        title: pageTitle
# 			        pageID: pageID
# 			    )  
# 			return pageID

# @getPageTitle = (pageID) ->
# 	if PageIDs.findOne({pageID: pageID}) # If we have the pageID already, return that.
# 		return PageIDs.findOne({pageID: pageID}).title
# 	else
# 		return 'noPageFound'


# @scrapeHistory = (pageTitles) ->
# 	counter = 1
# 	length = pageTitles.length
	
# 	scrapedHistory = {}
# 	scrapedIDs = {}

# 	for title in pageTitles
# 		linkSet = []
# 		pageID = getPageID(title)
# 		scrapedIDs[pageID] = title

# 		if pageID != '-1'
# 			# console.log counter + " of " + length
# 			# console.log title
# 			counter += 1

# 			if !Links.findOne({pageID: pageID})# If we have the pageID already, return that.
# 				# urltitle = title.replace(/\ /g, "_")
# 				# url ='http://en.wikipedia.org/w/api.php?format=json&action=query&titles=' + urltitle + '&redirects'
# 				# result = Meteor.http.get(url)

# 				# url = 'http://en.wikipedia.org/w/api.php?format=json&action=query&titles=' + title + '&prop=revisions&rvprop=content&redirects'
# 				url = 'http://en.wikipedia.org/w/api.php?format=json&action=query&pageids=' + pageID + '&redirects&generator=links&gpllimit=max'

# 				scrapeLinks(pageID, url) # will update linkSet

# 				Links.insert(
# 					pageID: pageID
# 					links: linkSet
# 				)
# 				console.log "new"

# 				# console.log linkSet.length
# 				if linkSet.length < 200000
# 					scrapedHistory[pageID] = linkSet
# 			else
# 				linksethere = Links.findOne({pageID: pageID}).links
# 				# console.log linksethere.length
# 				if linksethere.length < 200000
# 					scrapedHistory[pageID] = linksethere
# 				else
# 					# console.log title
# 					ppp=0
			
# 	# console.log scrapedHistory
# 	return [scrapedHistory, scrapedIDs]


# @createEdge = (pageID1, pageID2,edgesObject) ->
# 	# console.log "Edge of " + pageID1 + " " +pageID2
# 	# strength = 0
# 	# dir1 = Edges.findOne({src:pageID1, dest:pageID2}) 
# 	# dir1 = Edges.findOne({src:pageID1})[pageID2]
# 	# edgesObject = Edges.findOne({src:pageID1})
	

# 	if edgesObject
# 		# console.log "okay, I'm here"
# 		# console.log pageID2
# 		dir1 = edgesObject[pageID2]
# 		if dir1 > -1
			
# 			return dir1
		
# 	edgesObject2 = Edges.findOne({src:pageID2})
# 	if edgesObject2
# 		dir2 = edgesObject2[pageID1]

# 	# console.log edgesObject
# 	if edgesObject
		
# 		if dir2 > -1
# 			# console.log "wtf1"
# 			strength = dir2
# 			dummy = {}
# 			dummy[pageID2] = strength
# 			# console.log "write1"
# 			Edges.update(
# 				src: pageID1
# 			,
# 				$set:
# 					dummy
# 			)
# 			return strength
# 		else
# 			# console.log "wtf2"
# 			# console.log pageID1
# 			# console.log pageID2
# 			try
# 				linkList1 = Links.findOne({pageID: pageID1}).links
# 				linkList2 = Links.findOne({pageID: pageID2}).links
# 			catch
# 				linkList1 = []
# 				linkList2 = []
			
# 			strength = sharedLinkCount(linkList1, linkList2)
# 			dummy = {}
# 			dummy[pageID2] = strength
# 			# console.log "write2"
# 			Edges.update(
# 				src: pageID1
# 			,
# 				$set:
# 					dummy
# 			)
# 			return strength

# 	else

# 		if dir2
# 			# console.log "wtf3"
# 			strength = dir2
# 			dummy = {}
# 			dummy[pageID2] = strength
# 			# console.log "hereee" + dummy
# 			# console.log "write3"
# 			Edges.insert(
# 				src: pageID1
# 			)
# 			Edges.update(
# 				src: pageID1
# 			,
# 				$set:
# 					dummy
# 			)
# 			return strength
# 		else
# 			# console.log "wtf4"
# 			linkList1 = Links.findOne({pageID: pageID1}).links
# 			linkList2 = Links.findOne({pageID: pageID2}).links
# 			strength = sharedLinkCount(linkList1, linkList2)
# 			dummy = {}
# 			dummy[pageID2] = strength
# 			# console.log "write4"
# 			# console.log "hereee2 " + dummy[pageID2]
# 			Edges.insert(
# 				src: pageID1
# 			)
# 			Edges.update(
# 				src: pageID1
# 			,
# 				$set:
# 					dummy
# 			)
# 			return strength



# 	# if edgesObject
# 	# 	dir1 = edgesObject[pageID2]
	
# 	# 	if !dir1
# 	# 		# dir2 = Edges.findOne({src:pageID2, dest:pageID1}) 
			
# 	# 		if edgesObject2
# 	# 			dir2 = edgesObject2[pageID1]		
# 	# 			if dir2
# 	# 				strength = dir2
# 	# 		else
# 	# 			linkList1 = Links.findOne({pageID: pageID1}).links
# 	# 			linkList2 = Links.findOne({pageID: pageID2}).links
# 	# 	# 		# console.log linkList1
# 	# 	# 		# console.log linkList2
# 	# 			strength = sharedLinkCount(linkList1, linkList2)
# 	# 	console.log dummy
# 	# 	Edges.update(
# 	# 		src: pageID1
# 	# 	,
# 	# 		$set:
# 	# 			dummy
# 	# 	)


# 	# dummy = {}
# 	# dummy[pageID2] = strength
# 	# if edgesObject
# 	# 	console.log dummy
# 	# 	Edges.update(
# 	# 		src: pageID1
# 	# 	,
# 	# 		$set:
# 	# 			dummy
# 	# 	)
# 	# else
# 	# 	console.log "here"
# 	# 	console.log dummy
# 		# Edges.insert(
# 		# 	src: pageID1
# 		# 	dummy
# 		# )


# 	# 		# Edges.insert({src:pageID1, dest:pageID2,strength:strength})
# 	# # else
# 	# # 	strength = dir1.strength
# 	# return strength



# # # Build Network - and functions for building the network
# # #################################################

# # # @buildNetwork = (visitHistory, visitedTitles) ->
# # @buildNetwork = (scrapedHistory) ->
# # 	console.log "Building Network..."
# # 	# Need to build out. This will be the renderable network
# # 	# will include links as well as time stamps and the such
# # 	# visitHistory.push({url:e.url.split("#")[0], title:thisTitle, visitTime:e.lastVisitTime, visitCount:e.visitCount})
# # 	numInMin = .02
# # 	sharedMin = 1

# # 	firstHopNetwork = {}
# # 	count = 0
# # 	pageListLength = Object.keys(scrapedHistory).length
# # 	# console.log pageListLength
# # 	numInTitles = {}
# # 	totalOriginalTime=0;
# # 	totalNewTime = 0;

# # 	# Get and built numIn counts
# # 	for visit of scrapedHistory
# # 		pageID = visit
# # 		if pageID != '-1'
# # 			numIn = numInLink(pageID, scrapedHistory)
# # 			numInNormal = numIn/scrapedHistory[pageID].length
# # 			# console.log getPageTitle(pageID)
# # 			# console.log numInNormal
# # 			if numInNormal > numInMin
# # 				numInTitles[pageID] = numIn

# # 	# Get and build connections		
# # 	for page of numInTitles
# # 		pageID = page
# # 		pageTitle = getPageTitle(pageID) 
# # 		numIn = numInTitles[pageID]
# # 		# console.log 'PageTitle ' + pageTitle + ' | pageID ' + pageID + ' | numIn ' + numIn

# # 		index = count
# # 		connections = {}

# # 		# startTime = new Date().getTime()
# # 		for destPage of numInTitles
# # 			if parseInt(destPage) != parseInt(pageID)
# # 				sharedLinks= sharedLinkCount(scrapedHistory[pageID], scrapedHistory[destPage])
# # 				if sharedLinks > sharedMin
# # 					connections[destPage] = sharedLinks
# # 		# endTime = new Date().getTime()
# # 		# totalNewTime = (endTime-startTime)/1000



# # 		if Object.keys(connections).length > 0
			
# # 			# firstHopNetwork[pageID] = [index,pageTitle,numIn,connections]
# # 			firstHopNetwork[pageID] = [index,pageID,pageTitle,numIn,connections]
# # 			count += 1

 


# # 	# console.log firstHopNetwork
# # 	# console.log "New: " + totalNewTime + " seconds"
# # 	console.log "Done With Network..."
# # 	return firstHopNetwork



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


	

# # @numInLink = (pageID,scrapedHistory) ->
# # 	# console.log "HereNumInLInk"
# # 	pageTitle = getPageTitle(pageID)
# # 	inLinks = 0
# # 	for i of scrapedHistory
# # 		histID = i
# # 		histLinks = scrapedHistory[i]
# # 		try
# # 			# console.log page
# # 			# console.log Links.findOne({pageID:getPageID(page)})
# # 			if histLinks.indexOf(pageTitle) > -1
# # 				inLinks += 1
# # 		catch err
# # 			console.log histID
# # 			# console.log Links.findOne({pageID:getPageID(page)})
# # 			# console.log err
# # 	return inLinks














# @dontHaveThings = (historyValues, receivedHistoryTime, userID)	->
# 	visitHistory = []
# 	visitedTitles = []
# 	# userID = 'travis'
	
# 	scrapedIDs = {}

# 	startTime = new Date().getTime()
# 	console.log "Starting Title Building"
# 	# For each history item in value
# 	countyy = 0
# 	_.forEach historyValues, (e) ->
# 		# console.log countyy
# 		countyy += 1
# 		if testURL(e.url) # If the url is valid, according to testURL

# 	    	if e.title == ''
# 	    		thisTitle = goGetTitle(e.url)
# 	    		# baseURL = e.url.split("://")[1].split("#")[0]
# 	    		# console.log baseURL
# 	    		# thisTitle = PageIDs.findOne({url:baseURL})
# 	    		# console.log thisTitle
# 	    	else
# 	    		# console.log "sall good"
# 	    		thisTitle = e.title.split(" - Wiki")[0]

# 	    	visitedTitles.push(thisTitle)
# 	    	visitHistory.push({url:e.url.split("#")[0], title:thisTitle, visitTime:e.lastVisitTime, visitCount:e.visitCount})


# 	endTime = new Date().getTime()
# 	totalNewTime = (endTime-startTime)/1000
# 	console.log "Finished Title Building" + " | " + totalNewTime 
# 	console.log "Total Titles: " + visitedTitles.length
	



# 	startTime = new Date().getTime()
# 	console.log "Beginning Scrape History"
# 	scrapeHistory(visitedTitles)
# 	endTime = new Date().getTime()
# 	totalNewTime = (endTime-startTime)/1000
# 	console.log "Finished Scrape History" + " | " + totalNewTime 

# 	startTime = new Date().getTime()
# 	console.log "Beginning Build PageHistory"
# 	pageHistory = {}
# 	_.forEach visitHistory, (e) ->
# 		pageID = getPageID(e.title)
# 		PageIDs.update(
# 	        pageID: pageID
# 	    ,
# 	    	$set:
# 	    		url:e.url.split("://")[1].split("#")[0]
# 	    ) 
# 	    # if e.title == 'Mother sauce'
# 		   #  console.log PageIDs.findOne({pageID: pageID})

# 		# PageIDs.update(
# 		# 	accountID: userID
# 		# ,
# 		# 	$set:
# 		# 		# titles: visitedTitles
# 		# 		# history: visitHistory
# 		# 		# scrapedHistory: scrapedHistory[0]
# 		# 		# scrapedIDs: scrapedHistory[1]
# 		# 		# # networkData: networkData
# 		# 		# edges:myEdges
# 		# 		receivedHistoryTime: receivedHistoryTime
# 		# 		pageHistory: pageHistory
# 		# 		edges: myEdges
# 		# )

# 		pageHistory[pageID] = {url:e.url.split("#")[0], title:e.title, visitTime:e.visitTime, visitCount:e.visitCount}


# 	endTime = new Date().getTime()
# 	totalNewTime = (endTime-startTime)/1000
# 	console.log "Finished Build PageHistory" + " | " + totalNewTime 

#     # pageHistory = {id: {title, times, visitcount, url}}

#     # console.log "Herehere"

# 	startTime = new Date().getTime()
# 	console.log "Beginning Collect IDs"
# 	visitedIDs = []
# 	_.forEach visitedTitles, (title) ->
# 		pageID = getPageID(title)
# 		visitedIDs.push(pageID)
# 		scrapedIDs[pageID] = title
# 	# console.log "Herehere2"
# 	# console.log visitedIDs
	
# 	endTime = new Date().getTime()
# 	totalNewTime = (endTime-startTime)/1000
# 	console.log "Finished Collect IDs" + " | " + totalNewTime 



	
# 	# scrapedHistory = scrapeHistory(visitedTitles)
# 	# networkData = buildNetwork(scrapedHistory)
# 	# networkData = 0
# 	startTime = new Date().getTime()
# 	countx = 1
# 	lengthlength = visitedIDs.length
# 	console.log "Beginning Build Edges"
	
# 	_.forEach visitedIDs, (id1) ->
# 		# console.log countx + " of " + lengthlength

# 		edgesObject = Edges.findOne({src:id1})
# 		if !edgesObject
# 			# console.log "here"
# 			Edges.insert(
# 				src: id1
# 			)
# 			edgesObject = Edges.findOne({src:id1})
# 		countx += 1
# 		_.forEach visitedIDs, (id2) ->
# 			createEdge(id1,id2,edgesObject)


# 	endTime = new Date().getTime()
# 	totalNewTime = (endTime-startTime)/1000
# 	console.log "Finished Build Edges" + " | " + totalNewTime 



# 	startTime = new Date().getTime()


# 	console.log "Beginning Collect My Edges"

# 	count1 = 0
# 	count5 = 0
# 	count2 = 0
# 	count10 = 0
# 	myEdges = []
# 	_.forEach visitedIDs, (id1) ->
# 		# console.log id1
# 		src_edges = Edges.findOne({src:id1}) 
# 		_.forEach visitedIDs, (id2) ->
# 			# console.log src_edges
# 			strengthVal = src_edges[id2]
# 			if strengthVal > 0
# 				if strengthVal > 10
# 					count10++
# 					myEdges.push({src:id1, dest:id2, strength:strengthVal})
# 				else if strengthVal > 5
# 					count5++
# 					myEdges.push({src:id1, dest:id2, strength:strengthVal})
# 				else if strengthVal > 2
# 					count2++
# 				else if strengthVal > 1
# 					count1++

				
# 	# console.log "Edges length " + myEdges.length
# 	# console.log "count1 " + count1
# 	# console.log "count2 " + count2
# 	# console.log "count5 " + count5
# 	# console.log "count10 " + count10
# 			# console.log id1
# 			# if id1 != id2
# 				# if myEdges[id1]
# 				# 	myEdges[id1][id2] = createEdge(id1,id2)
# 				# else
# 					# myEdges[id1]= {id2: createEdge(id1,id2)}
# 				# if myEdges[id1]
# 				# 	myEdges[id1][id2] = srcedges[id2]
# 				# else
# 				# 	myEdges[id1]= {id2: srcedges[id2]}
	
# 	endTime = new Date().getTime()
# 	totalNewTime = (endTime-startTime)/1000	
# 	console.log "Finished Collect My Edges" + " | " + totalNewTime 

# 	# compare = (a, b) ->
# 	#   return -1  if a.last_nom < b.last_nom
# 	#   return 1  if a.last_nom > b.last_nom
# 	#   0
# 	# objs.sort compare

# 	# console.log myEdges
# 	console.log "done"

# 	# pageHistory = {id: {title, times, visitcount, url}}
# 	# edges = [{src, dest, strength},...]

# 	# Strange, the message seems to get sent back to the extension before all the links are scraped. 
# 	# Since update gets set to true, it just winds up reading the old wikiData 
# 	# Need to have the function check if the server is done. Can we set session variables from server?
# 	if WikiData.findOne({accountID:userID})
# 		# console.log "got it4"
# 		WikiData.update(
# 			accountID: userID
# 		,
# 			$set:
# 				# titles: visitedTitles
# 				# history: visitHistory
# 				# scrapedHistory: scrapedHistory[0]
# 				# scrapedIDs: scrapedHistory[1]
# 				# # networkData: networkData
# 				# edges:myEdges
# 				receivedHistoryTime: receivedHistoryTime
# 				pageHistory: pageHistory
# 				edges: myEdges
# 				scrapedIDs: scrapedIDs
# 		)
# 		# console.log "got it3"
# 	else
# 		# console.log "got it"
# 		WikiData.insert(
# 			accountID: userID
# 			# titles: visitedTitles
# 			# history: visitHistory
# 			# scrapedHistory: scrapedHistory[0]
# 			# scrapedIDs: scrapedHistory[1]
# 			# # networkData: networkData
# 			# edges:myEdges
# 			receivedHistoryTime: receivedHistoryTime
# 			pageHistory: pageHistory
# 			edges: myEdges
# 			scrapedIDs: scrapedIDs
# 		)
# 		# console.log "got it2"



