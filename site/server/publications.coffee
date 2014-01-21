Meteor.publish "wikiDataPub", () ->
    console.log "just Updated"
    return WikiData.find()



Meteor.methods printVal: (value) ->
	# console.log value
	visitHistory = []
	visitedTitles = []
	userID = 'travis'
	console.log value
	# For each history item in value
	_.forEach value, (e) ->
		if testURL(e.url) # If the url is valid, according to testURL
	    	if e.title == ''
	    		thisTitle = goGetTitle(e.url)
	    	else
	    		thisTitle = e.title.split(" - Wiki")[0]

	    	visitedTitles.push(thisTitle)
	    	visitHistory.push({url:e.url.split("#")[0], title:thisTitle, visitTime:e.lastVisitTime, visitCount:e.visitCount})
    		
	    	# console.log {url:e.url.split("#")[0], title:thisTitle, visitTime:e.lastVisitTime, visitCount:e.visitCount}
    
    
	console.log "Here2"
	scrapeHistory(visitedTitles)
	networkData = 0
	# console.log myresult
	# networkData = buildNetwork(visitHistory)

	if WikiData.findOne({accountID:userID})
		console.log "Here"
		WikiData.update(
			accountID: userID
		,
			$set:
				titles: visitedTitles
				history: visitHistory
				networkData: networkData
		)
		# WikiData.update(
	    #     accountID: userID
	    #     titles: visitedTitles
	    #     history: visitHistory
	    # )
	else
	   WikiData.insert(
	        accountID: userID
	        titles: visitedTitles
	        history: visitHistory
	        networkData: networkData
	    )


# @testTitle = (title) ->
# # Test if the title is acceptable, 
# 	if 

# 		str = "Hello world!"

# #look for "Hello"
# isFile = /File:/g
# isCategory = /Category:/g

# result = patt.test(str)
# document.write "Returned value: " + result

@buildNetwork = (visitHistory) ->

@goGetTitle = (url) ->
	# Parse url,
	# Get Page api
	# 
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
# Test if url is redirect, if it is, return the proper url
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
# require = __meteor_bootstrap__.require; //to use npm require must be exposed.
@scrapeLinks = (pageID,url) ->
	result = Meteor.http.get(url)
	# $ = cheerio.load(result.content)
	# CurrentTime = $.root()
	# mything = JSON.parse(result)
	
	if result.data.hasOwnProperty('query-continue')
		# console.log result.data['query-continue']['links']['gplcontinue']
		continueURL ='http://en.wikipedia.org/w/api.php?format=json&action=query&pageids=' + pageID + '&redirects&generator=links&gpllimit=max&gplcontinue='+result.data['query-continue']['links']['gplcontinue']
		console.log "Continuing with " + continueURL

		linkSet.concat(scrapeLinks(pageID, continueURL))
		# console.log linkSet

	for link of result.data['query']['pages']
		# console.log link
		# console.log result.data['query']['pages'][link]['title']
		if link > 0 # Bad pages get thrown as -1
			isFile = /File:/g
			isCategory = /Category:/g
			isTemplate = /Template:/g
			isTemplateTalk = /Template talk:/g
			isHelp = /Help:/g
			isWikipedia = /Wikipedia:/g
			isPortal = /Portal:/g
			isUser = /User:/g
			pageTitle = result.data['query']['pages'][link]['title']
			if(!isFile.test(pageTitle) and !isCategory.test(pageTitle) and !isTemplate.test(pageTitle) and !isHelp.test(pageTitle) and !isWikipedia.test(pageTitle) and !isPortal.test(pageTitle) and !isTemplateTalk.test(pageTitle) and !isUser.test(pageTitle))
				linkSet.push(pageTitle)
	

	
	
	return linkSet



# Write a function to get id given page name
# create collections that store name > id
# create collection that stores id > links 

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

# Meteor.methods getTime: () ->
@scrapeHistory = (pageTitles) ->
	console.log "Here3"
	console.log pageTitles
	# cheerio = Meteor.require('cheerio')
	counter = 1
	length = pageTitles.length
	for title in pageTitles
		linkSet = []
		pageID = getPageID(title)
		if !Links.findOne({pageID: pageID})# If we have the pageID already, return that.
			# allLinks = []
			
			# getPageID('Boston')
			# console.log getPageTitle('24437894')


			# title = "Cat"
			urltitle = title.replace(/\ /g, "_")

			# Get page id, and use that
			url ='http://en.wikipedia.org/w/api.php?format=json&action=query&titles=' + urltitle + '&redirects'
			result = Meteor.http.get(url)
			
			# for page of result.data['query']['pages']
			# 	pageID = page
			# 	if(!PageIDs.findOne({title: title})) # If this is a new pageID, add it to the collection
			# 		PageIDs.insert(
			# 	        title: title
			# 	        pageID: pageID
			# 	    )   

			# url = 'http://en.wikipedia.org/w/api.php?format=json&action=query&titles=' + title + '&prop=revisions&rvprop=content&redirects'
			url = 'http://en.wikipedia.org/w/api.php?format=json&action=query&pageids=' + pageID + '&redirects&generator=links&gpllimit=max'

			scrapeLinks(pageID, url) # will update linkSet
			# console.log linkSet

			Links.insert(
				pageID: pageID
				links: linkSet
			)
			console.log "new"
		console.log counter + " of " + length
		counter += 1





