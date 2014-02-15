import pymongo
import json
import requests
import time
import sys
import cProfile


# Load all links 
# Iterate over and compare
# create master object array that has {id:{id1:5,id7:13}}

def main ():
	# def sharedLinkCount (list1, list2):
	# 	# Compare two pages by counting the number of links they share.
	# 	# Can be used to define the link strength between between two nodes.

	# 	return len(list1.intersection(list2))

	######################################

	connection = pymongo.Connection(host='127.0.0.1', port=3002)
	try:
		db = connection.meteor
	except:
		print "Can't seem to find the meteor database"

	c_wikiLinks = db.wikilinks
	c_wikiStrengths = db.wikistrengths

	allLinks = {}
	allIDs = set()
	allResults = []

	print "Loading Pages"
	linksDB = c_wikiLinks.find()
	for page in linksDB:
		pageID =  page['pageID']
		pageLinks = set(page['links'])
		allLinks[pageID] = pageLinks
		allIDs.add(pageID)
	linksDB = None # Clear the links from memory
	print "Loaded # Pages: " + str(len(allIDs))


	print "Beginning Links Calculation"
	totalPages = 100000 
	# totalPages = 2000
	startTime = time.time()
	counter = 0
	finishedPages = 0
	taskNum = int(sys.argv[1]) - 1
	for pageID1 in allIDs:
		if counter > ((taskNum*100000)-1) and counter < ((taskNum+1)*100000):
			connections = {}
			list1 = allLinks[pageID1]
			for pageID2 in allIDs:
				if pageID1 != pageID2 :
					list2 = allLinks[pageID2]
					# sharedCount = sharedLinkCount(list1, list2)
					sharedCount = len(list1.intersection(list2))
					if sharedCount > 1:
						connections[pageID2] = sharedCount
			allResults.append({'pageID':pageID1, 'strengths': connections})
			finishedPages += 1
			# print counter
			if finishedPages % 100 == 0:
				lapTime = time.time()
				print "Remaining Time: " + str((lapTime-startTime)/finishedPages*(totalPages-finishedPages)/60) + " minutes"

		counter += 1
		
	print "Adding to mongo..."
	c_wikiStrengths.insert(allResults)
	print "Done!"

main()
# cProfile.run('main()')