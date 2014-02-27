import pickle
import sys
import pymongo

# allIDs = pickle.load(open("allIDs.p", "rb")) 

connection = pymongo.Connection(host='127.0.0.1', port=3001)
try:
	db = connection.meteor
except:
	print "Can't seem to find the meteor database"

c_topmillion = db.topmillion
c_wikilinks = db.wikilinks

topmil =  c_topmillion.find()
allLinkDocs = c_wikilinks.find()

titleDict = {}
# IDDict = {}
print "Got # docs: " + str((allLinkDocs.count()))

# count = 0
for page in topmil:
	# print page
	title = page['articleTitle']
	pageID = page['pageID']

	titleDict[pageID] = title
	# IDDict[title] = pageID

	# count += 1
	# if count % 10000 == 0:
		# print count
print "Built titleDict"
# print titleDict

# pickle.dump(titleDict, open( "idToTitleDict.p", "wb" ) )
# pickle.dump(IDDict, open( "titleToIdDict.p", "wb" ) )

	# c_wikilinks.update(
	#    { 'pageID' : pageID },
	#    { 'articleTitle' : title }
	# )
	
count = 0
allLinksPages = []
for page in allLinkDocs:
	# print page
	allLinksPages.append(page)
print len(allLinksPages)

for page in allLinksPages:
	pageID = page["pageID"]
	title = titleDict[pageID]

	# print page
	titledLinks = []
	for link in page["links"]:
		titledLinks.append({'title':titleDict[link],'pageID':link})
	# print titledLinks

	# titleDict[pageID] = title
	# IDDict[title] = pageID

	c_wikilinks.update(
		{ 'pageID' : pageID },
		{ 'articleTitle' : title, 'titledLinks':  titledLinks, 'pageID':pageID, 'links':page["links"]}
	)

	count += 1
	if count % 1000 == 0:
		print count
