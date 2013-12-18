
#  Data for directPages link count
maxCount = directPages[max(directPages.iteritems(), key=operator.itemgetter(1))[0]]
directlinkCountArray = [0]*maxCount # each index (N) represents having N+1 number of links. The value of that index represents how many sites contain N+1 links

for item in directPages:
	directlinkCountArray[directPages[item]-1] += 1


#  Data for firsthopPages link count
maxCount = firsthopPages[max(firsthopPages.iteritems(), key=operator.itemgetter(1))[0]]
firstlinkCountArray = [0]*maxCount # each index (N) represents having N+1 number of links. The value of that index represents how many sites contain N+1 links

for item in firsthopPages:
	firstlinkCountArray[firsthopPages[item]-1] += 1


#  Data for secondhopPages link count
maxCount = secondhopPages[max(secondhopPages.iteritems(), key=operator.itemgetter(1))[0]]
secondlinkCountArray = [0]*maxCount # each index (N) represents having N+1 number of links. The value of that index represents how many sites contain N+1 links

for item in secondhopPages:
	secondlinkCountArray[secondhopPages[item]-1] += 1


sorted_direct = sorted(directPages.iteritems(), key=operator.itemgetter(1), reverse=True)
# max(directPages.iteritems(), key=operator.itemgetter(1))[0]
# print sorted_direct

sorted_first = sorted(firsthopPages.iteritems(), key=operator.itemgetter(1), reverse=True)
# max(directPages.iteritems(), key=operator.itemgetter(1))[0]
# print sorted_x

sorted_second = sorted(secondhopPages.iteritems(), key=operator.itemgetter(1), reverse=True)
# max(directPages.iteritems(), key=operator.itemgetter(1))[0]
# print sorted_x

pickle.dump( sorted_direct, open( "sorted_direct.p", "wb" ) )
pickle.dump( sorted_first, open( "sorted_first.p", "wb" ) )
pickle.dump( sorted_second, open( "sorted_second.p", "wb" ) )


import pickle
import numpy as np
import matplotlib.pyplot as plt

sorted_direct = pickle.load(open("sorted_direct.p", "rb"))	
sorted_first = pickle.load(open("sorted_first.p", "rb"))	
sorted_second = pickle.load(open("sorted_second.p", "rb"))	

x_direct = []
x_first = []
x_second = []

for item in sorted_direct:
	x_direct.append(item[1])

for item in sorted_first:
	x_first.append(item[1])

for item in sorted_second:
	x_second.append(item[1])

linkStrengthList = {}