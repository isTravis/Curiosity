Meteor.publish "wikiDataPub", () ->
    console.log "just Updated"
    return WikiData.find()



Meteor.methods inputHistory: (value) ->

	visitHistory = []
	visitedTitles = []
	userID = 'travis'

	# For each history item in value
	_.forEach value, (e) ->
		if testURL(e.url) # If the url is valid, according to testURL
	    	if e.title == ''
	    		thisTitle = goGetTitle(e.url)
	    	else
	    		thisTitle = e.title.split(" - Wiki")[0]

	    	visitedTitles.push(thisTitle)
	    	visitHistory.push({url:e.url.split("#")[0], title:thisTitle, visitTime:e.lastVisitTime, visitCount:e.visitCount})

    
    
	scrapeHistory(visitedTitles)
	networkData = 0
	# networkData = buildNetwork(visitHistory)

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
				networkData: networkData
		)
	else
	   WikiData.insert(
	        accountID: userID
	        titles: visitedTitles
	        history: visitHistory
	        networkData: networkData
	    )



@buildNetwork = (visitHistory) ->
	# Need to build out. This will be the renderable network
	# will include links as well as time stamps and the such

@goGetTitle = (url) ->
	# Use when the history search result returns a title of ''
	urlTitle = url.split("wiki/")[1].split("#")[0]
	apiURL = 'http://en.wikipedia.org/w/api.php?format=json&action=query&titles=' + urlTitle + '&redirects&prop=revisions'
	result = Meteor.http.get(apiURL)
	# console.log result
	for page of result.data['query']['pages']
		pageID = page
		# console.log pageID
	if pageID != -1
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
		
		if(isTalk.test(parsedURL) or isAPI.test(parsedURL) or isFile.test(parsedURL) or isCategory.test(parsedURL) or isTemplate.test(parsedURL) or isHelp.test(parsedURL) or isWikipedia.test(parsedURL) or isPortal.test(parsedURL) or isTemplateTalk.test(parsedURL) or isUser.test(parsedURL))
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
			pageTitle = result.data['query']['pages'][link]['title']
			if(!isFile.test(pageTitle) and !isCategory.test(pageTitle) and !isTemplate.test(pageTitle) and !isHelp.test(pageTitle) and !isWikipedia.test(pageTitle) and !isPortal.test(pageTitle) and !isTemplateTalk.test(pageTitle) and !isUser.test(pageTitle) and !isAPI.test(pageTitle) and !isTalk.test(pageTitle))
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
			if pageID != -1
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
	for title in pageTitles
		linkSet = []
		pageID = getPageID(title)
		if !Links.findOne({pageID: pageID})# If we have the pageID already, return that.
			urltitle = title.replace(/\ /g, "_")
			url ='http://en.wikipedia.org/w/api.php?format=json&action=query&titles=' + urltitle + '&redirects'
			result = Meteor.http.get(url)

			# url = 'http://en.wikipedia.org/w/api.php?format=json&action=query&titles=' + title + '&prop=revisions&rvprop=content&redirects'
			url = 'http://en.wikipedia.org/w/api.php?format=json&action=query&pageids=' + pageID + '&redirects&generator=links&gpllimit=max'

			scrapeLinks(pageID, url) # will update linkSet

			Links.insert(
				pageID: pageID
				links: linkSet
			)
			console.log "linkset length : " + linkSet.length
			console.log "new"
		console.log counter + " of " + length
		counter += 1










