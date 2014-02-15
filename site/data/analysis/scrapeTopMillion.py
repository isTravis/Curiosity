# Get list of top million IDs
# Scrape each ID, iterate through continues and redirects
# Build a master list, everytually add everything to mongo in one go


import pymongo
import json
import requests
import time
import sys

def scrapePage (pageID, url):
	request = requests.get(url).json()
	if 'query-continue' in request:
		continueURL ='http://en.wikipedia.org/w/api.php?format=json&action=query&pageids=' + pageID + '&redirects&generator=links&gpllimit=max&indexpageids&gplcontinue='+request['query-continue']['links']['gplcontinue']
		# print continueURL
		scrapePage(pageID, continueURL)
	# print pageID
	for link in request['query']['pageids']:
		if link in allIDs:
			linkList.append(link)


######################################

masterList = [] # Holds all data, at end adds to mongo
linkList = [] # Is a temp variable and gets erased on each loop

connection = pymongo.Connection(host='127.0.0.1', port=3002)
try:
	db = connection.meteor
except:
	print "Can't seem to find the meteor database"

c_wikiLinks = db.wikilinks
c_topmillion = db.topmillion
topMillion = c_topmillion.find()

# print "Loading Top Million Pages"
allIDs = set()
counter = 0
taskNum = int(sys.argv[1]) # Call file as "python scrapeTopMillion.py 5"
print "Loading Pages " + str(taskNum*100000) + " Through " + str((1+taskNum)*100000)
for page in topMillion:
	if counter > ((taskNum*100000)-1) and counter < ((taskNum+1)*100000):
		allIDs.add(page['pageID'])
	counter += 1
topMillion = None # Clear the million results from memory
# print len(allIDs)

print "Beginning Links Scrape"
totalPages = 100000
startTime = time.time()
counter = 0
for pageID in allIDs:
	try:
		linkList = []
		url = 'http://en.wikipedia.org/w/api.php?format=json&action=query&pageids=' + pageID + '&redirects&generator=links&gpllimit=max&indexpageids'
		scrapePage(pageID,url)
		masterList.append({'pageID':pageID, 'links':linkList})

		counter += 1
		if counter % 1000 == 0:
			print "----------------"
			print counter
			lapTime = time.time()
			print "Remaining Time: " + str((lapTime-startTime)/counter*(totalPages-counter)/60) + " minutes"
	except:
		print "Something messed up on page " + pageID
	
	
print "Adding to mongo..."
c_wikiLinks.insert(masterList)
print "Done!"
