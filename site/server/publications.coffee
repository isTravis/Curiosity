Meteor.publish "wikiDataPub", () ->
    console.log "just Updated"
    return WikiData.find()



# Meteor.methods printVal: (value) ->
#     # console.log value
#     myresult = []
#     getTime()
#     _.forEach value, (e) ->

#     	# if testURL(e.url)
# 	    # 	console.log e.url
    	 
#     	# e.lastVisitTime
#     	# e.title
#     	# e.url
#     	# e.visitCount

#     	myresult.push(e.title)
#     # console.log myresult
#     WikiData.insert(
#         numVal: myresult
#     )   


# @testTitle = (title) ->
# # Test if the title is acceptable, 
# 	if 

# 		str = "Hello world!"

# #look for "Hello"
# isFile = /File:/g
# isCategory = /Category:/g

# result = patt.test(str)
# document.write "Returned value: " + result



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
		isTempalte = /Template:/g
		isAPI = /api.php/g

		if(isFile.test(parsedURL) or isCategory.test(parsedURL) or isAPI.test(parsedURL))
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
			isHelp = /Help:/g
			isWikipedia = /Wikipedia:/g
			pageTitle = result.data['query']['pages'][link]['title']
			if(!isFile.test(pageTitle) and !isCategory.test(pageTitle) and !isTemplate.test(pageTitle) and !isHelp.test(pageTitle) and !isWikipedia.test(pageTitle))
				linkSet.push(pageTitle)
	

	
	
	return linkSet


Meteor.methods getTime: () ->
	# cheerio = Meteor.require('cheerio')
	allLinks = []
	
	title = 'Steve_Jobs'

	# Get page id, and use that
	url ='http://en.wikipedia.org/w/api.php?format=json&action=query&titles=' + title + '&redirects'
	result = Meteor.http.get(url)
	for page of result.data['query']['pages']
		pageID = page


	# url = 'http://en.wikipedia.org/w/api.php?format=json&action=query&titles=' + title + '&prop=revisions&rvprop=content&redirects'
	url = 'http://en.wikipedia.org/w/api.php?format=json&action=query&pageids=' + pageID + '&redirects&generator=links&gpllimit=max'

	console.log scrapeLinks(pageID, url).length
	console.log linkSet






