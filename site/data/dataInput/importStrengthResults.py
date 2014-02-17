import pickle
import pymongo
import sys


connection = pymongo.Connection(host='127.0.0.1', port=3002)
try:
	db = connection.meteor
except:
	print "Can't seem to find the meteor database"


c_wikiStrengths = db.wikistrengths

# Iterate through all results (1-20, inclusive)
# Add it to the mongo collection

taskNum = int(sys.argv[1])

# for i in range (1,21):
# for i in range (1,2):
print "Starting to add allResults_" + str(taskNum)
tempResults = pickle.load(open( "../datasets/pickledData/allResults_" + str(taskNum) + ".p", "rb" )) 
c_wikiStrengths.insert(tempResults)
tempResults = None
print "Finished with " + str(taskNum)

print "Done!"