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

rankedPageIDs = []

for i in range(1,1000001):
	pageID = int(c_topmillion.find_one({'rank': i})['pageID'])
	rankedPageIDs.append(pageID)
	if i % 100000 == 0:
		print i

pickle.dump(rankedPageIDs, open( "rankedPageIDs.p", "wb" ) )
