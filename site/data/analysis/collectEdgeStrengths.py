# Collects edge strengths and puts it into a pickle for python placement.

# load graph
# iterate through all vertices
# 	iterate through all edges
# 		create objects with edge and strength
# 	push to master pickle

# save master pickle

# {1092:[{543:2},{2134:13}],2523:[{234:2},{12345:3}]}
import sys, os
from pylab import *  # for plotting
from numpy.random import *  # for random sampling
from graph_tool.all import *
import time
import pickle
import operator

def main():
	g = load_graph("fullNet_noedgeslessthan5.xml.gz")
	idToIndex = pickle.load(open( "nodeIndexes.p", "rb" )) 
	indexToID = pickle.load(open( "indexToID.p", "rb" )) 
	rankedPageIDs = pickle.load(open( "rankedPageIDs.p", "rb" )) 

	strengths = g.edge_properties["strength"]



	linksAndStrengths = {}

	finishedPages = 0
	totalPages = 999821
	startTime = time.time()

	# counter = 0
	# for v in g.vertices():
	for sourceID in rankedPageIDs:
		# if finishedPages > 5:
		# 	break
		try:
			vertexIndex = idToIndex[sourceID]
			v = g.vertex(vertexIndex)
			edgeStrengths = []
			for e in v.all_edges():
				targetIndex = g.vertex_index[e.target()]
				targetID = indexToID[targetIndex]
				edgeStrengths.append({targetID:strengths[e]})
			newlist = sorted(edgeStrengths, key=lambda x:x.values(), reverse=True)
			# newlist = sorted(xxx, key=lambda x:map(operator.itemgetter(1), x), reverse=True)
			# print edgeStrengths
			# print "--"
			# print newlist[:50]
			# print "-----------------"
			# linksAndStrengths[sourceID] = edgeStrengths
			linksAndStrengths[sourceID] = newlist[:8]
		except:
			linksAndStrengths[sourceID] = []
		# print sourceID
		# print edgeStrengths
		# print "--------------------------------"
		finishedPages += 1
		lapTime = time.time()
		if finishedPages%1000 == 0:
			print "Finished " + str(finishedPages)
			print "Remaining Time: " + str((lapTime-startTime)/finishedPages*(totalPages-finishedPages)/60) + " minutes"
			print "-------------------------"

	pickle.dump(linksAndStrengths, open( "linksAndStrengths_noedgeslessthan5_8neighbors.p", "wb" ) )

main()


# indexToID = {}
# for pageID in idToIndex:
# 	graphIndex = idToIndex[pageID]
# 	# print "key is " + str(key) + " | value is " + str(value)
# 	indexToID[graphIndex] = pageID
# pickle.dump(indexToID, open( "indexToID.p", "wb" ) )