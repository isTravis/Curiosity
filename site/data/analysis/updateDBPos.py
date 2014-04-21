import time
import pickle
import pymongo


myMap = pickle.load(open( "myMap3.p", "rb" )) 


connection = pymongo.Connection(host='127.0.0.1', port=3001)
try:
	db = connection.meteor
except:
	print "Can't seem to find the meteor database"

c_topmillion = db.topmillion

#iterate through the map, update each object in mongo

counter = 0
for thisx in range(0,1250):
	for thisy in range (0,800):
		# print str(thisx) + " " + str(thisy)
		pageID = myMap[thisx][thisy]
		# pageID = 0
		# print "---"
		
		# if len(c_topmillion.find_one({ 'pageID' : str(pageID) })) == 0:
			# print pageID
				
		c_topmillion.update(
		   { 'pageID' : str(pageID) },
		   { '$set' : { 'x': thisx, 'y':thisy } }
		)
		# c_topmillion.update(
		#    { 'pageID' : str(pageID) },
		#    { '$set' : { 'y': thisy } }
		# )
		# print c_topmillion.find_one({ 'pageID' : str(pageID) })

		counter += 1

		if counter % 50000 == 0:
			print counter