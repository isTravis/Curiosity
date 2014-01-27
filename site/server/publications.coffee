# Meteor.publish "wikiDataPub", (historyValues, receivedHistoryTime) ->
#     console.log "just Updated"
#     # console.log "updated " + updated
#     # if updated 
#     console.log "Beginning new"
#     beginEverything(historyValues, receivedHistoryTime)
#     console.log "finished updated"
#     return WikiData.find()


Meteor.publish "wikiDataPub", (historyValues, receivedHistoryTime) ->
    console.log "just Updated"
    # console.log "updated " + updated
    # if updated 
    console.log "Beginning new"
    beginEverything(historyValues, receivedHistoryTime)
    console.log "finished updated"
    return WikiData.find()



# Meteor.methods inputHistory: (value) ->
	# if WikiData.findOne({accountID:userID})
	# 	WikiData.update(
	# 		accountID: userID
	# 	,
	# 		$set:
	# 			toSend: 'false'
	# 	)
@beginEverything = (historyValues, receivedHistoryTime) ->

	visitHistory = []
	visitedTitles = []
	userID = 'travis'

	# For each history item in value
	_.forEach historyValues, (e) ->
		if testURL(e.url) # If the url is valid, according to testURL
	    	if e.title == ''
	    		thisTitle = goGetTitle(e.url)
	    	else
	    		thisTitle = e.title.split(" - Wiki")[0]

	    	visitedTitles.push(thisTitle)
	    	visitHistory.push({url:e.url.split("#")[0], title:thisTitle, visitTime:e.lastVisitTime, visitCount:e.visitCount})

    
    # console.log "Herehere"
	visitedIDs = []
	_.forEach visitedTitles, (title) ->
		visitedIDs.push(getPageID(title))
	# console.log "Herehere2"
	# console.log visitedIDs





	scrapedHistory = scrapeHistory(visitedTitles)
	# networkData = buildNetwork(scrapedHistory)
	# networkData = 0
	myEdges = {}
	_.forEach visitedIDs, (id1) ->
		console.log id1
		srcedges = Edges.findOne({src:id1}) 
		_.forEach visitedIDs, (id2) ->
			# console.log id1
			# if id1 != id2
				# if myEdges[id1]
				# 	myEdges[id1][id2] = createEdge(id1,id2)
				# else
					# myEdges[id1]= {id2: createEdge(id1,id2)}
				# if myEdges[id1]
				# 	myEdges[id1][id2] = srcedges[id2]
				# else
				# 	myEdges[id1]= {id2: srcedges[id2]}
					
	

	# compare = (a, b) ->
	#   return -1  if a.last_nom < b.last_nom
	#   return 1  if a.last_nom > b.last_nom
	#   0
	# objs.sort compare

	console.log myEdges
	console.log "done"
	# Strange, the message seems to get sent back to the extension before all the links are scraped. 
	# Since update gets set to true, it just winds up reading the old wikiData 
	# Need to have the function check if the server is done. Can we set session variables from server?
	if WikiData.findOne({accountID:userID})
		WikiData.update(
			accountID: userID
		,
			$set:
				titles: visitedTitles
				history: visitHistory
				# scrapedHistory: scrapedHistory[0]
				# scrapedIDs: scrapedHistory[1]
				# networkData: networkData
				edges:myEdges
				receivedHistoryTime: receivedHistoryTime
		)
	else
	   WikiData.insert(
	        accountID: userID
	        titles: visitedTitles
	        history: visitHistory
	        # scrapedHistory: scrapedHistory[0]
	        # scrapedIDs: scrapedHistory[1]
	        # networkData: networkData
	        edges:myEdges
	        receivedHistoryTime: receivedHistoryTime
	    )



@goGetTitle = (url) ->
	# Use when the history search result returns a title of ''
	urlTitle = url.split("wiki/")[1].split("#")[0]
	apiURL = 'http://en.wikipedia.org/w/api.php?format=json&action=query&titles=' + urlTitle + '&redirects&prop=revisions'
	result = Meteor.http.get(apiURL)
	# console.log result
	for page of result.data['query']['pages']
		pageID = page
		# console.log pageID
	if pageID != '-1'
		# And now add to collection
		title = result.data['query']['pages'][pageID]['title']
		return title
	else
		return ''


@testURL = (url) ->
	# Test to make sure the url is what we're looking for. Checks a number of different aspects

	isWiki = /wikipedia.org\/wiki\//g # Gets rid of api calls and such
	if isWiki.test(url)
		# url = 'http://en.wikipedia.org/wiki/Samsung_Galaxy_Tab#Cat'
		urlHead = url.split("://")[1].split("wiki/")[0]
		
		if urlHead != 'en.wikipedia.org/' and urlHead !='en.m.wikipedia.org/'
			return false;
		# console.log( urlHead == 'en.wikipedia.org/' )

		# url = 'http://en.wikipedia.org/w/api.php?format=json&action=query&titles=Saudia_Arabia&prop=revisions&rvprop=content'
		parsedURL = url.split("wiki/")[1].split("#")[0] # Takes the string after /wiki/ (and before # if it exists)
		isFile = /File:/g
		isCategory = /Category:/g
		isTemplate = /Template:/g
		isTemplateTalk = /Template talk:/g
		isHelp = /Help:/g
		isWikipedia = /Wikipedia:/g
		isPortal = /Portal:/g
		isUser = /User:/g
		isAPI = /api.php/g
		isTalk = /Talk:/g
		isSpecial = /Special:/g
		
		if(isSpecial.test(parsedURL) or isTalk.test(parsedURL) or isAPI.test(parsedURL) or isFile.test(parsedURL) or isCategory.test(parsedURL) or isTemplate.test(parsedURL) or isHelp.test(parsedURL) or isWikipedia.test(parsedURL) or isPortal.test(parsedURL) or isTemplateTalk.test(parsedURL) or isUser.test(parsedURL))
			return false
		return true
	else
		return false


linkSet = []

@scrapeLinks = (pageID,url) ->
	result = Meteor.http.get(url)
	
	if result.data.hasOwnProperty('query-continue')
		# console.log result.data['query-continue']['links']['gplcontinue']
		continueURL ='http://en.wikipedia.org/w/api.php?format=json&action=query&pageids=' + pageID + '&redirects&generator=links&gpllimit=max&gplcontinue='+result.data['query-continue']['links']['gplcontinue']
		# console.log "Continuing with " + continueURL

		linkSet.concat(scrapeLinks(pageID, continueURL))

	for link of result.data['query']['pages']

		if link > 0 # Bad pages get thrown as -1
			isFile = /File:/g
			isCategory = /Category:/g
			isTemplate = /Template:/g
			isTemplateTalk = /Template talk:/g
			isHelp = /Help:/g
			isWikipedia = /Wikipedia:/g
			isPortal = /Portal:/g
			isUser = /User:/g
			isAPI = /api.php/g
			isTalk = /Talk:/g
			isSpecial = /Special:/g
			pageTitle = result.data['query']['pages'][link]['title']
			if(!isSpecial.test(pageTitle) and !isFile.test(pageTitle) and !isCategory.test(pageTitle) and !isTemplate.test(pageTitle) and !isHelp.test(pageTitle) and !isWikipedia.test(pageTitle) and !isPortal.test(pageTitle) and !isTemplateTalk.test(pageTitle) and !isUser.test(pageTitle) and !isAPI.test(pageTitle) and !isTalk.test(pageTitle))
				linkSet.push(pageTitle)
	
	return linkSet


@getPageID = (pageTitle) ->
	if PageIDs.findOne({title: pageTitle}) # If we have the pageID already, return that.
		return PageIDs.findOne({title: pageTitle}).pageID
	else
		urltitle = pageTitle.replace(/\ /g, "_")
		# Get page id, and use that
		url ='http://en.wikipedia.org/w/api.php?format=json&action=query&titles=' + urltitle + '&redirects'
		result = Meteor.http.get(url)
		for page of result.data['query']['pages']
			pageID = page
			# console.log pageID
			if pageID != '-1'
				# And now add to collection
				PageIDs.insert(
			        title: pageTitle
			        pageID: pageID
			    )  
			return pageID

@getPageTitle = (pageID) ->
	if PageIDs.findOne({pageID: pageID}) # If we have the pageID already, return that.
		return PageIDs.findOne({pageID: pageID}).title
	else
		return 'noPageFound'


@scrapeHistory = (pageTitles) ->
	counter = 1
	length = pageTitles.length
	
	scrapedHistory = {}
	scrapedIDs = {}

	for title in pageTitles
		linkSet = []
		pageID = getPageID(title)
		scrapedIDs[pageID] = title

		if pageID != '-1'
			# console.log counter + " of " + length
			# console.log title
			counter += 1

			if !Links.findOne({pageID: pageID})# If we have the pageID already, return that.
				# urltitle = title.replace(/\ /g, "_")
				# url ='http://en.wikipedia.org/w/api.php?format=json&action=query&titles=' + urltitle + '&redirects'
				# result = Meteor.http.get(url)

				# url = 'http://en.wikipedia.org/w/api.php?format=json&action=query&titles=' + title + '&prop=revisions&rvprop=content&redirects'
				url = 'http://en.wikipedia.org/w/api.php?format=json&action=query&pageids=' + pageID + '&redirects&generator=links&gpllimit=max'

				scrapeLinks(pageID, url) # will update linkSet

				Links.insert(
					pageID: pageID
					links: linkSet
				)
				console.log "new"

				# console.log linkSet.length
				if linkSet.length < 200
					scrapedHistory[pageID] = linkSet
			else
				linksethere = Links.findOne({pageID: pageID}).links
				# console.log linksethere.length
				if linksethere.length < 800
					scrapedHistory[pageID] = linksethere
				else
					console.log title
			
	# console.log scrapedHistory
	return [scrapedHistory, scrapedIDs]


@createEdge = (pageID1, pageID2) ->
	# console.log "Edge of " + pageID1 + " " +pageID2
	strength = 0
	# dir1 = Edges.findOne({src:pageID1, dest:pageID2}) 
	# dir1 = Edges.findOne({src:pageID1})[pageID2]
	
	# if !dir1
	# 	dir2 = Edges.findOne({src:pageID2, dest:pageID1}) 		
	# 	if dir2
	# 		strength = dir2.strength
	# 	else
	# 		linkList1 = Links.findOne({pageID: pageID1}).links
	# 		linkList2 = Links.findOne({pageID: pageID2}).links
	# 		# console.log linkList1
	# 		# console.log linkList2
	# 		strength = sharedLinkCount(linkList1, linkList2)
	# 		Edges.insert({src:pageID1, dest:pageID2,strength:strength})
	# else
	# 	strength = dir1.strength
	return strength



# # Build Network - and functions for building the network
# #################################################

# # @buildNetwork = (visitHistory, visitedTitles) ->
# @buildNetwork = (scrapedHistory) ->
# 	console.log "Building Network..."
# 	# Need to build out. This will be the renderable network
# 	# will include links as well as time stamps and the such
# 	# visitHistory.push({url:e.url.split("#")[0], title:thisTitle, visitTime:e.lastVisitTime, visitCount:e.visitCount})
# 	numInMin = .02
# 	sharedMin = 1

# 	firstHopNetwork = {}
# 	count = 0
# 	pageListLength = Object.keys(scrapedHistory).length
# 	# console.log pageListLength
# 	numInTitles = {}
# 	totalOriginalTime=0;
# 	totalNewTime = 0;

# 	# Get and built numIn counts
# 	for visit of scrapedHistory
# 		pageID = visit
# 		if pageID != '-1'
# 			numIn = numInLink(pageID, scrapedHistory)
# 			numInNormal = numIn/scrapedHistory[pageID].length
# 			# console.log getPageTitle(pageID)
# 			# console.log numInNormal
# 			if numInNormal > numInMin
# 				numInTitles[pageID] = numIn

# 	# Get and build connections		
# 	for page of numInTitles
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

 


# 	# console.log firstHopNetwork
# 	# console.log "New: " + totalNewTime + " seconds"
# 	console.log "Done With Network..."
# 	return firstHopNetwork



@sharedLinkCount = (linkList1, linkList2) ->
  linkList1.sort()
  linkList2.sort()
  ai = bi = 0
  result = []
  while ai < linkList1.length and bi < linkList2.length
    # console.log a[ai]
    # console.log b[bi]
    if linkList1[ai] < linkList2[bi]
      ai++
    else if linkList1[ai] > linkList2[bi]
      bi++
    # they're equal 
    else
      result.push ai
      ai++
      bi++
  return result.length


	

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
















