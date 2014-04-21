import time
import pickle
from pprint import pprint

# myNet = pickle.load(open( "allLinks.p", "rb" )) 
myNet = pickle.load(open( "linksAndStrengths_noedgeslessthan5_8neighbors.p", "rb" )) 
rankedPageIDs = pickle.load(open( "rankedPageIDs.p", "rb" )) 

# myMap2 = pickle.load(open( "myMap2.p", "rb" )) 

print "Done importing"
# myNet = {1:[2,3], 
# 		2:[1,3],
# 		3:[1,2,4],
# 		4:[3,5],
# 		5:[4,6,10],
# 		6:[5,7,8,9],
# 		7:[5,6,8,9],
# 		8:[5,6,7,9],
# 		9:[5,6,7,8],
# 		10:[5,11,12,13],
# 		11:[10,12,13],
# 		12:[10,11,13],
# 		13:[10,11,12],
# 		14:[15],
# 		15:[14],
# 		16:[]
# 	}


# print myNet[15]

myMap = []
placed = {}


for i in range (0, 1250):      
	new = []                 
	for j in range (0,800):  
		new.append(0)      
	myMap.append(new)

# print mymap

lastd = 1
lasti = 0
lastj = 1




def findNearestOpen(xs,ys):
	maxDistance = 10000

	if myMap[xs][ys] == 0:
		return [xs,ys]

	while 1:
		for d in range(1,maxDistance):
			for i in range(0,d+1):
				x1 = xs - d + i
				y1 = ys - i
				if x1 >= 0 and y1 >=0:
					try:
						if myMap[x1][y1] == 0:
							return [x1,y1]
					except IndexError:
						# print "hit a wall"
						wall =0


				x2 = xs + d - i
				y2 = ys + i
				if x2 >= 0 and y2 >=0:
					try:
						if myMap[x2][y2] == 0:
							return [x2,y2]
					except IndexError:
						# print "hit a wall"
						wall =0

			for i in range(1,d):

				x1 = xs - i
				y1 = ys + d - i
				if x1 >= 0 and y1 >=0:
					try:
						if myMap[x1][y1] == 0:
							return [x1,y1]
					except IndexError:
						# print "hit a wall"
						wall =0

				x2 = xs + d - i
				y2 = ys - i
				if x2 >= 0 and y2 >=0:
					try:
						if myMap[x2][y2] == 0:
							return [x2,y2]
					except IndexError:
						# print "hit a wall"
						wall =0


def findNearestOpenCenter(xs,ys):
	maxDistance = 10000

	if myMap[xs][ys] == 0:
		return [xs,ys]

	while 1:
		global lastd
		global lasti
		global lastj

		for d in range(lastd,maxDistance):
			lastd = d
			for i in range(lasti,d+1):
				lasti = i
				x1 = xs - d + i
				y1 = ys - i
				if x1 >= 0 and y1 >=0:
					try:
						if myMap[x1][y1] == 0:
							return [x1,y1]
					except IndexError:
						# print "hit a wall"
						wall =0


				x2 = xs + d - i
				y2 = ys + i
				if x2 >= 0 and y2 >=0:
					try:
						if myMap[x2][y2] == 0:
							return [x2,y2]
					except IndexError:
						# print "hit a wall"
						wall =0
			lasti = 0


			for j in range(lastj,d):
				lastj = j
				x1 = xs - j
				y1 = ys + d - j
				if x1 >= 0 and y1 >=0:
					try:
						if myMap[x1][y1] == 0:
							return [x1,y1]
					except IndexError:
						# print "hit a wall"
						wall =0

				x2 = xs + d - j
				y2 = ys - j
				if x2 >= 0 and y2 >=0:
					try:
						if myMap[x2][y2] == 0:
							return [x2,y2]
					except IndexError:
						# print "hit a wall"
						wall =0
			lastj = 1


# myMap[2][2] = 1
# myMap[1][2] = 1
# myMap[3][2] = 1
# myMap[2][1] = 1
# myMap[2][3] = 1
# myMap[0][2] = 1
# myMap[1][1] = 1
# myMap[3][3] = 1
# myMap[2][0] = 1
# myMap[1][3] = 1
# print findNearestOpen(2,2)
# pprint(myMap)

def placeNode(node):
	positionAverageX = 0
	positionAverageY = 0
	numAverages = 0
	links = myNet[node]
	for link in links:
		targetID = link.keys()[0]
		targetStrength = link.values()[0]
		
		if targetID in placed:
			positionAverageX += placed[targetID][0]*targetStrength
			positionAverageY += placed[targetID][1]*targetStrength
			numAverages += 1*targetStrength

	if numAverages == 0:
		positionAverageX = 625
		positionAverageY = 400
		results = findNearestOpenCenter(positionAverageX,positionAverageY)

	else:
		# print "numavg " + str(numAverages)
		# print positionAverageX
		# print positionAverageY
		positionAverageX = int(positionAverageX/numAverages)
		positionAverageY = int(positionAverageY/numAverages)
		results = findNearestOpen(positionAverageX,positionAverageY)

	# print positionAverageX
	# print positionAverageY
	# print "-----"
	

	# results = findNearestOpen(positionAverageX,positionAverageY)
	# print "result is "
	# print results
	placed[node] = results
	myMap[results[0]][results[1]] = node

	# print('\n'.join([''.join(['{:4}'.format(item) for item in row]) 
 #      for row in myMap]))
	# print "------"



	#iterate through links, check if any have been placeNode
	#with placed links, average the location
	#pass  that average location to findNearestOpen
	# update global map with the value

finishedPages = 0
totalPages = 999821
startTime = time.time()

for node in rankedPageIDs:

	placeNode(node)

	finishedPages += 1
	lapTime = time.time()

	if finishedPages%1000 == 0:
		print lastd
		print "Finished " + str(finishedPages)
		print "Remaining Time: " + str((lapTime-startTime)/finishedPages*(totalPages-finishedPages)/60) + " minutes"
		print "-------------------------"

pickle.dump( myMap, open( "myMap3.p", "wb" ) )

# print('\n'.join([''.join(['{:4}'.format(item) for item in row]) 
#       for row in myMap]))