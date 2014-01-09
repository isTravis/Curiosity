#!/usr/bin/python
'''
Analyze network and dump it to a D3-able graph.
'''
import json
import pickle

# nodes.append({"name":"Napoleon","group":8})
# links.append({"source":1,"target":0,"value":1})

def buildFirstHopNetwork(numInMin, sharedMin, pageList):
	firstHopNetwork = {}
	count = 0
	pageListLength = len(pageList)
	for page in pageList:
		pageTitle = page
		numIn = numInlink(page)
		# if numIn > numInMin:
		index = count
		connections = {}
		for destPage in pageList:
			sharedLinks = sharedLinkCount(page, destPage)
			if sharedLinks > sharedMin:
				connections[destPage] = sharedLinks
		firstHopNetwork[page] = [index,pageTitle,numIn,connections]
		print "Building Network: Page " + str(count+1) + " of " + str(pageListLength)
		count += 1
	return firstHopNetwork
	# pickle.dump( firstHopNetwork, open( "../datasets/firstHopNetwork1.p", "wb" ) )


def createJSON(network):
	nodes = []
	links = []
	count = 0
	missedConnections = 0
	networkLength = len(network)
	wtfcounter = 0
	# for page in network:
	for i in range(networkLength):
		page = {}
		for thispage in network:
			if network[thispage][0] == i:
				page = thispage
		if wtfcounter > 5000:
			break
		print "Formatting Data: Page " + str(count+1) + " of " + str(networkLength)
		index = network[page][0]
		print "Compare: " +str(wtfcounter) + " " + str(index)
		title = network[page][1]
		inLinks = network[page][2]
		# if inLinks > 0:
		nodes.append({"name":title,"inlinks":inLinks})
		# nodes.append({"name":title,"inlinks":1})
		print "network[page][3]: " 
		print network[page][3]
		for connection in network[page][3]:
			connectionTitle = connection
			print "Connection title: " + connectionTitle
			try:
				connectionIndex = network[connectionTitle][0]
				if connectionIndex != index:
					connectionStrength = sharedLinkCount(title, connectionTitle)
					links.append({"source":index,"target":connectionIndex,"value":connectionStrength})
			except:
				missedConnections +=1
		count += 1
		wtfcounter += 1
	print "Missed Connections: " + str(missedConnections)
	outputJSON = {"nodes":nodes,"links":links}
	# Write .json file out
	with open('../../public/netDataTest.json', 'w') as outfile:
	  json.dump(outputJSON, outfile, sort_keys=True, indent=3, separators=(',', ': '))


createJSON(mNetwork)


def sharedLinkCount (pageTitle1, pageTitle2):
	# Compare two pages by counting the number of links they share.
	# Can be used to define the link strength between between two nodes.
	try:
		return len(set(masterPageLinks[pageTitle1.lower()]) & set(masterPageLinks[pageTitle2.lower()]))
	except:
		return 0

def numInlink (pageTitle):
	# times = time.time()
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






# Main Code Calls
# --------------------------
print "Importing masterPageLinks..."
masterPageLinks = pickle.load(open("../datasets/masterPageLinks.p", "rb")) 
print "Importing directPages..."
directPages = pickle.load(open("../datasets/directPages.p", "rb")) 
print "Importing directPages_normalized..."
directPages_normalized = pickle.load(open("../datasets/directPages_normalized.p", "rb")) 

mNetwork = buildFirstHopNetwork(5,15, directPages_normalized)
createJSON(mNetwork)




# firsthopValidation = {}
# count = 1
# for page in firsthopPages:
# 	print count
# 	count += 1
# 	firsthopValidation[page] = str(inlinksFromDirect(page))

# firsthopValidation_sorted = sorted(firsthopValidation.iteritems(), key=operator.itemgetter(1), reverse=True)






# Some structure (or maybe just a function that queries bluh) that denotes a page. It contains, the page title, url, incoming links, outgoing links, confidence rating, number of links on page, network connections (perhaps you can set a threshold for network connections - you take the top 10 or top 20, and then build your visualization)
	# -Probably want to pick a small threshold (maybe even just 1), send that to client, and then let the client-side filter
	# Maybe this structure, built around their direct history, is what you send the client.
