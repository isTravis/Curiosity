# open up the votes collection
# check for the number of votes
# check for number of gifs
# if the number of votes, given all those gifs, is sufficient, 
# 	add new gifs into the proper db.


#Open articledata
#open the goodpages log file
# iterate through all lines
# check if article id already exists.
# 	if no, add it to db
# 	if yes, increment the count by this count

import pymongo
# from lxml import html
import json
# import requests
import time
import operator

connection = pymongo.Connection(host='127.0.0.1', port=3002)

try:
	db = connection.meteor
except:
	print "Can't seem to find the meteor database"

c_articleData = db.articledata
# c_gifs = db.gifs
in_file = open("../datasets/wikiDataSets/validPages3", 'r')

addedPageIDs = set() # For now, lets use a python set to keep track of IDs instead of a millino DB reads
# That won't let us incrementally add pages in the future, but strating from an empty db, it should be faster
totalPages = 6673967
startTime = time.time()
articleArray = []

articleDict = {}
viewDict = {}
addLater = {}
count = 0
for lineItem in in_file.readlines():
	splitLine = lineItem.split(' | ')
	thisID = splitLine[0].strip()
	if thisID in addedPageIDs:
		# We already have the site, just increment it's value
		thisViewCount = int(splitLine[3].strip())
		articleDict[thisID]['viewCount'] = articleDict[thisID]['viewCount'] + thisViewCount

		viewDict[thisID] = viewDict[thisID] + thisViewCount
		# if thisID in addLater:
		# 	addLater[thisID] += thisViewCount
		# else:
		# 	addLater[thisID] = thisViewCount
		# c_articleData.update(
		#    { 'pageID' : thisID },
		#    { '$inc' : { 'viewCount': thisViewCount } }
		# )
	else:
		# We don't have this page yet, add a new item to the db.
		articleTitle = splitLine[1].strip()
		thisViewCount = int(splitLine[3].strip())
		addedPageIDs.add(thisID)

		# construct object and then...
		# Add it to db
		articleData = {'pageID': thisID, 'articleTitle': articleTitle, 'viewCount':thisViewCount}
		# c_articleData.insert(articleData)
		# articleArray.append(articleData)
		articleDict[thisID] = articleData
		viewDict[thisID] = thisViewCount


	count+= 1
	# if count %10000 == 0:
	if count %100000 == 0:
		print "----------------"
		# if len(articleArray):
		# 	c_articleData.insert(articleArray)

		# print "Number of existing Objects " + str(len(addLater))
		# for item in addLater:
		# 	c_articleData.update(
		# 	   { 'pageID' : item },
		# 	   { '$inc' : { 'viewCount': addLater[item] } }
		# 	)

		# addLater = {}
		# articleArray = []
		print count
		lapTime = time.time()
		print "Remaining Read Time: " + str((lapTime-startTime)/count*(totalPages-count)/60) + " minutes"

	# if count > 200:
	# 	break

sorted_articles = sorted(viewDict.iteritems(), key=operator.itemgetter(1), reverse=True)
# print sorted_articles
outputJSON = []
outputArticles = 10000
outputCounter = 1
for item in sorted_articles:
	thisID = item[0]
	thisViewCount = item[1]
	thisTitle = articleDict[thisID]['articleTitle']
	x = {'pageID':thisID, 'articleTitle' :thisTitle, 'viewCount' :thisViewCount}
	outputJSON.append(x)
	# print item
	# print x
	outputCounter += 1
	if outputCounter > outputArticles:
		break


with open('../datasets/wikiDataSets/topPages.json', 'w') as outfile:
  json.dump(outputJSON, outfile, sort_keys=True, indent=3, separators=(',', ': '))
# count = 0
# startTime = time.time()
# for item in articleDict:
# 	# print item
# 	# print articleDict[item]
# 	articleArray.append(articleDict[item])
# 	count+= 1
# 	# if count %10000 == 0:
# 	if count %10000 == 0:
# 		print "----------------"
# 		# if len(articleArray):
# 		# 	c_articleData.insert(articleArray)

# 		# print "Number of existing Objects " + str(len(addLater))
# 		# for item in addLater:
# 		# 	c_articleData.update(
# 		# 	   { 'pageID' : item },
# 		# 	   { '$inc' : { 'viewCount': addLater[item] } }
# 		# 	)

# 		# addLater = {}
# 		# articleArray = []
# 		print count
# 		lapTime = time.time()
# 		print "Remaining Add Time: " + str((lapTime-startTime)/count*totalPages/60) + " minutes"

# c_articleData.insert(articleArray)


