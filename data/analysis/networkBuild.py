


def sharedLinkCount (pageTitle1, pageTitle2):
	# Compare two pages by counting the number of links they share.
	# Can be used to define the link strength between between two nodes.
	try:
		return len(set(masterPageLinks[pageTitle1.lower()]) & set(masterPageLinks[pageTitle2.lower()]))
	except:
		return 0

# times = time.time()
# numbers = []
# count = 1
# for page1 in directPages:
# 	for page2 in directPages:
# 		try:
# 			numlinks = sharedLinkCount(page1, page2)
# 			numbers.append(numlinks)
# 		except:
# 			print "oops"
# 	print count
# 	count += 1

# print("Total time was: " + str(time.time()-times) + " seconds")

# numbers_sorted = sorted(sorted.iteritems(), key=operator.itemgetter(1), reverse=True)


def numInlinkMethod (pageTitle):
	times = time.time()
	inLinks = 0
	for page in directPages:
		try:
			if pageTitle in masterPageLinks[page.lower()]:
				inLinks += 1
		except:
			waste = 0
	# print("Total time was: " + str(time.time()-times) + " seconds")
	return inLinks

# Given a page, how many of it's links are things you've visited directly
def inlinksFromDirect(pageTitle):
	totalInLinks = 0
	try:
		for link in masterPageLinks[pageTitle.lower()]: # For every link on the page...
			if link in directPages: # check if that link is one you directly visited
				totalInLinks += 1
				# print link
	except:
		x = 0
	return totalInLinks

firstHopNetwork = {}
count = 1
for page in directPages:
	print count
	count += 1
	pageTitle = page
	numIn = numInlinkMethod(page)
	connections = {}
	for destPage in directPages:
		sharedLinks = sharedLinkCount(page, destPage)
		if sharedLinks > 1:
			connections[destPage] = sharedLinks
	firstHopNetwork[page] = [pageTitle,numIn,connections]


pickle.dump( firstHopNetwork, open( "../datasets/firstHopNetwork1.p", "wb" ) )


firsthopValidation = {}
count = 1
for page in firsthopPages:
	print count
	count += 1
	firsthopValidation[page] = str(inlinksFromDirect(page))

firsthopValidation_sorted = sorted(firsthopValidation.iteritems(), key=operator.itemgetter(1), reverse=True)



# Some structure (or maybe just a function that queries… bluh) that denotes a page. It contains, the page title, url, incoming links, outgoing links, confidence rating, number of links on page, network connections (perhaps you can set a threshold for network connections - you take the top 10 or top 20, and then build your visualization)
	# -Probably want to pick a small threshold (maybe even just 1), send that to client, and then let the client-side filter
	# Maybe this structure, built around their direct history, is what you send the client.
