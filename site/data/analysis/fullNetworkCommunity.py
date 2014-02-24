import sys, os
from pylab import *  # for plotting
from numpy.random import *  # for random sampling
from graph_tool.all import *
import time
import pickle


def minimize_blockmodel_dl():

	startTime = time.time()
	print "Loading Graph..."
	g = load_graph("fullnet_small.xml.gz")
	print "Done loading Graph"
	finishTime = time.time()
	print "Took " + str((finishTime-startTime)/60) + " minutes to load graph"

	startTime = time.time()
	strengths = g.edge_properties["strength"]
	b, mdl = graph_tool.community.minimize_blockmodel_dl(g,eweight=strengths,verbose=True)
	finishTime = time.time()
	print "Total Time: " + str((finishTime-startTime)/60) + " minutes"

	pickle.dump(b, open( "testNetwork_b.p", "wb" ) )
	pickle.dump(mdl, open( "testNetwork_mdl.p", "wb" ) )
	graph_draw(g, pos=g.vp["pos"], vertex_fill_color=b, vertex_shape=b, output="fullNetwork_blocks_mdl.pdf")


def sfdp_layout():
	startTime = time.time()
	print "Loading Graph..."
	g = load_graph("fullnet_small.xml.gz")
	print "Done loading Graph"
	finishTime = time.time()
	print "Took " + str((finishTime-startTime)/60) + " minutes to load graph"

	startTime = time.time()
	strengths = g.edge_properties["strength"]
	pos = graph_tool.draw.sfdp_layout(g, eweight=strengths, verbose=True, max_iter=1)
	finishTime = time.time()
	print "Total Time: " + str((finishTime-startTime)/60) + " minutes"
	
	pickle.dump(pos, open( "testNetwork_pos_1iter.p", "wb" ) )
	graph_draw(g, pos=pos, output="graph-draw-sfdp_1iter.pdf")

# minimize_blockmodel_dl()
sfdp_layout()



# strengths = g.edge_properties["strength"]
# inrange = find_edge_range(g,strengths,[0,1])
# for e in g.edges():
# 	count += 1
# for e in inrange:
# 	g.remove_edge(e)

# g.save("fullNet_small_noedgeslessthan2.xml.gz")


# for v in g.vertices

