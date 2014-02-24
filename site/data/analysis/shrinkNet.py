import sys, os
from pylab import *  # for plotting
from numpy.random import *  # for random sampling
from graph_tool.all import *
import time
import pickle



# def removeEdges2():
# 	startTime = time.time()
# 	totalVertices = g.num_vertices()
# 	verticeIndex = 0
# 	deleted = 0
# 	for v in g.vertices():
# 		toDelete = []
# 		for e in v.all_edges():
# 			if strengths[e] < 5:
# 				toDelete.append(e)
# 		for e in toDelete:
# 			g.remove_edge(e)
# 			deleted += 1
# 		verticeIndex += 1
# 		if verticeIndex % 1000 == 0:
# 			lapTime = time.time()
# 			print "Finished " + str(verticeIndex)
# 			print "Remaining Time: " + str((lapTime-startTime)/verticeIndex*(totalVertices-verticeIndex)/60) + " minutes"
# 			print "-------------------------"
# 	print "Just Deleted " + str(deleted) + " edges!"
# 	print "Remaining edges: " + str(g.num_edges())
# 	g.save("fullNet_noedgeslessthan5.xml.gz")
 
# 	g.save("fullNet_small_noedgeslessthan2_reducedvertices.xml.gz")
# degreePropMap = g.degree_property_map("total")
# degreePropMap = g.degree_property_map("total",weight=strengths)

def main():
	startTime = time.time()
	print "Loading Graph..."
	g = load_graph("../fullNet.xml.gz")
	# g = load_graph("fullNet_small.xml.gz")
	print "Done loading Graph"
	finishTime = time.time()
	print "Took " + str((finishTime-startTime)/60) + " minutes to load graph"
  
	strengths = g.edge_properties["strength"]
	
	startTime = time.time()
	totalVertices = g.num_vertices()
	verticeIndex = 0
	deleted = 0
	for v in g.vertices():
		toDelete = []
		for e in v.all_edges():
			if strengths[e] < 5:
				toDelete.append(e)
		for e in toDelete:
			g.remove_edge(e)
			deleted += 1
		verticeIndex += 1
		if verticeIndex % 10000 == 0:
			lapTime = time.time()
			print "Finished " + str(verticeIndex)
			print "Remaining Time: " + str((lapTime-startTime)/verticeIndex*(totalVertices-verticeIndex)/60) + " minutes"
			print "-------------------------"
	print "Just Deleted " + str(deleted) + " edges!"
	print "Remaining edges: " + str(g.num_edges())
	finishTime = time.time()
	print "Took " + str((finishTime-startTime)/60) + " minutes to remove edges"
	g.save("fullNet_noedgeslessthan5.xml.gz")
	# inrange = find_edge_range(g,strengths,[0,5])


	# # allEdgesCount = 0
	# # for e in g.edges():
	# # 	allEdgesCount += 1

	# # print "Have a total of " + str(allEdgesCount) + " edges."
	# print g.num_edges()
	# print g.num_vertices()

	# for e in inrange:
	# 	g.remove_edge(e)

	# # reducedEdgesCount = 0
	# # for e in g.edges():
	# # 	reducedEdgesCount += 1

	# print "Reduced to " + str(g.num_edges()) + " edges."

	# g.save("fullNet_small_noedgeslessthan5.xml.gz")

	# totalVertices = 0
	# while its not min , call callit a bunch
	# but it seemed like we could make a property map of the degree, and then just remove all those

# def removeVertex():
# 	try:
# 		for v in g.vertices():
# 			if v.out_degree() == 0:
# 				g.remove_vertex(v, fast=True)
# 	except:
# 		yy = 0
# 	reducedVertexCount = 0
# 	for v in g.vertices():
# 		reducedVertexCount += 1
# 	print "Reduced to " + str(reducedVertexCount) + " vertices."
# 	return reducedVertexCount
 
# 	g.save("fullNet_small_noedgeslessthan2_reducedvertices.xml.gz")

# def removeEdges():
# 	try:
# 		for e in g.edges():
# 			if strengths[e] < 2:
# 				g.remove_edge(e)
# 	except:
# 		yy = 0
# 	reducedEdgesCount = 0
# 	for e in g.edges():
# 		reducedEdgesCount += 1
# 	print "Reduced to " + str(reducedEdgesCount) + " vertices."
# 	return reducedEdgesCount

main()

