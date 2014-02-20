# Want to:
# Build network
# Determine Clusters
# Update positions

import pymongo
import time
import sys
import pickle

def main():
	connection = pymongo.Connection(host='127.0.0.1', port=3002)
	try:
		db = connection.meteor
	except:
		print "Can't seem to find the meteor database"

	c_wikiStrengths = db.wikistrengths

	print "Loading Pages"
	allStrengths = c_wikiStrengths.find()
	huge = []
	count = 0
	nonZero = 0
	more1 = 0
	more10 = 0
	more100 = 0
	more1000 = 0
	more10000 = 0
	for thing in allStrengths:
		count += 1
		
		if len(thing['strengths']) > 10000:
			more10000 += 1
			more1000 += 1
			more100 += 1
			more10 += 1
			more1 += 1
			nonZero += 1
		elif len(thing['strengths']) > 1000:
			more1000 += 1
			more100 += 1
			more10 += 1
			more1 += 1
			nonZero += 1
		elif len(thing['strengths']) > 100:
			more100 += 1
			more10 += 1
			more1 += 1
			nonZero += 1
		elif len(thing['strengths']) > 10:
			more10 += 1
			more1 += 1
			nonZero += 1
		elif len(thing['strengths']) > 1:
			more1 += 1
			nonZero += 1
		elif len(thing['strengths']):
			nonZero += 1
		
			# print thing['pageID'] + " | " + str(len(thing['strengths']))
			# huge.append(thing)
		if count % 10000 == 0:
			print count

	print "About To Pause for 60 seconds"
	print "nonzero " + str(nonZero)
	print "more1 " + str(more1)
	print "more10 " + str(more10)
	print "more100 " + str(more100)
	print "more1000 " + str(more1000)
	print "more10000 " + str(more10000)




main()